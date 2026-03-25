import 'package:hive_flutter/hive_flutter.dart';
import '../models/kaza_model.dart';
import '../services/widget_service.dart';
import '../services/interaction_service.dart';

class KazaRepository {
  static const String _boxName = 'kaza_box';
  static const String _historyBoxName = 'kaza_history_box';
  static const String _key = 'user_kaza';
  static const String _settingsBoxName = 'settings_box';
  static const String _voluntaryFastsBoxName = 'voluntary_fasts_box';
  static const String _tasbihBoxName = 'tasbih_box';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
    await Hive.openBox<int>(_historyBoxName);
    await Hive.openBox(_settingsBoxName);
    await Hive.openBox<String>(_voluntaryFastsBoxName);
    await Hive.openBox(_tasbihBoxName);
  }

  Box get _box => Hive.box(_boxName);
  Box<int> get _historyBox => Hive.box<int>(_historyBoxName);
  Box<String> get _voluntaryFastsBox =>
      Hive.box<String>(_voluntaryFastsBoxName);
  Box get _tasbihBox => Hive.box(_tasbihBoxName);

  Map<String, int> getTasbihData() {
    return {
      'count': _tasbihBox.get('count', defaultValue: 0) as int,
      'laps': _tasbihBox.get('laps', defaultValue: 0) as int,
      'target': _tasbihBox.get('target', defaultValue: 33) as int,
    };
  }

  Future<void> saveTasbihData({
    required int count,
    required int laps,
    required int target,
  }) async {
    await _tasbihBox.put('count', count);
    await _tasbihBox.put('laps', laps);
    await _tasbihBox.put('target', target);
  }

  KazaModel getKazaData() {
    final data = _box.get(_key);
    if (data == null) {
      return const KazaModel();
    }
    // Hive stores Map<dynamic, dynamic> by default
    return KazaModel.fromMap(Map<dynamic, dynamic>.from(data)).resetIfNeeded();
  }

  Future<void> saveKazaData(KazaModel data) async {
    await _box.put(_key, data.toMap());
    await WidgetService.updateWidget(data);
  }

  Future<void> _logActivity(int count) async {
    final today = DateTime.now();
    // Normalize date to YYYYMMDD string for simple key
    final key =
        "${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";

    final currentCount = _historyBox.get(key) ?? 0;
    await _historyBox.put(key, currentCount + count);
  }

  Map<DateTime, int> getHistory() {
    final Map<DateTime, int> history = {};
    final keys = _historyBox.keys;
    for (var key in keys) {
      final keyStr = key.toString();
      if (keyStr.length == 8) {
        final year = int.parse(keyStr.substring(0, 4));
        final month = int.parse(keyStr.substring(4, 6));
        final day = int.parse(keyStr.substring(6, 8));
        history[DateTime(year, month, day)] = _historyBox.get(key) ?? 0;
      }
    }
    return history;
  }

  List<DateTime> getVoluntaryFasts() {
    final List<DateTime> fasts = [];
    for (var key in _voluntaryFastsBox.keys) {
      fasts.add(DateTime.parse(key.toString()));
    }
    return fasts;
  }

  Future<void> toggleVoluntaryFast(DateTime date) async {
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    if (_voluntaryFastsBox.containsKey(dateStr)) {
      await _voluntaryFastsBox.delete(dateStr);
    } else {
      await _voluntaryFastsBox.put(dateStr, dateStr);

      // Award XP for voluntary fasting
      final current = getKazaData();
      final updated = current.countPrayer(5); // 50 XP
      await InteractionService.success();
      await saveKazaData(updated);
    }
  }

  double getDailyAverageRate() {
    final history = getHistory();
    if (history.isEmpty) return 0;

    // Get last 7 days of activity
    final sortedDates = history.keys.toList()..sort((a, b) => b.compareTo(a));
    final last7Days = sortedDates.take(7);

    if (last7Days.isEmpty) return 0;

    int total = 0;
    for (var date in last7Days) {
      total += history[date] ?? 0;
    }

    return total / last7Days.length;
  }

  DateTime? getExpectedCompletionDate() {
    final data = getKazaData();
    final remaining = data.totalRemaining - data.fasting; // Prayers only
    if (remaining <= 0) return null;

    final rate = getDailyAverageRate();
    if (rate <= 0) return null;

    final daysRemaining = (remaining / rate).ceil();
    return DateTime.now().add(Duration(days: daysRemaining));
  }

  Future<void> decrementPrayer(PrayerType type, [int amount = 1]) async {
    final current = getKazaData();
    int newValue = current.getCount(type) - amount;
    if (newValue < 0) newValue = 0;

    KazaModel updated;
    switch (type) {
      case PrayerType.fajr:
        updated = current.copyWith(fajr: newValue);
        break;
      case PrayerType.dhuhr:
        updated = current.copyWith(dhuhr: newValue);
        break;
      case PrayerType.asr:
        updated = current.copyWith(asr: newValue);
        break;
      case PrayerType.maghrib:
        updated = current.copyWith(maghrib: newValue);
        break;
      case PrayerType.isha:
        updated = current.copyWith(isha: newValue);
        break;
      case PrayerType.witr:
        updated = current.copyWith(witr: newValue);
        break;
      case PrayerType.fasting:
        updated = current.copyWith(fasting: newValue);
        break;
    }

    // Apply leveling logic
    if (newValue < current.getCount(type)) {
      updated = updated.countPrayer(amount);
      await InteractionService.success();
    }

    await saveKazaData(updated);
    await _logActivity(amount);
    await _updateStreaksAndAchievements();
  }

  Future<void> incrementSunnah(PrayerType type, [int amount = 1]) async {
    final current = getKazaData();
    KazaModel updated = current;

    switch (type) {
      case PrayerType.fajr:
        updated = current.copyWith(sunnahFajr: current.sunnahFajr + amount);
        break;
      case PrayerType.dhuhr:
        updated = current.copyWith(sunnahDhuhr: current.sunnahDhuhr + amount);
        break;
      case PrayerType.asr:
        updated = current.copyWith(sunnahAsr: current.sunnahAsr + amount);
        break;
      case PrayerType.maghrib:
        updated = current.copyWith(
          sunnahMaghrib: current.sunnahMaghrib + amount,
        );
        break;
      case PrayerType.isha:
        updated = current.copyWith(sunnahIsha: current.sunnahIsha + amount);
        break;
      default:
        break;
    }

    // Award bonus XP/virtual coins for Sunnah (e.g., 5 coins)
    updated = updated.copyWith(
      virtualCoins: updated.virtualCoins + (amount * 5),
    );
    updated = updated.countPrayer((amount * 0.5).ceil());
    await InteractionService.success();

    await saveKazaData(updated);
  }

  Future<void> incrementNafl([int amount = 1]) async {
    final current = getKazaData();
    KazaModel updated = current.copyWith(
      nafl: current.nafl + amount,
      virtualCoins: current.virtualCoins + (amount * 5),
    );

    // Award bonus XP for Nafl
    updated = updated.countPrayer((amount * 0.5).ceil());
    await InteractionService.success();

    await saveKazaData(updated);
  }

  Future<void> updateQuranProgress(int surah, int page) async {
    final current = getKazaData();
    final updated = current.copyWith(
      lastQuranSurah: surah,
      lastQuranPage: page,
    );
    await saveKazaData(updated);
    await InteractionService.success();
  }

  Future<bool> unlockTheme(int themeColor, int cost) async {
    final current = getKazaData();
    if (current.virtualCoins >= cost &&
        !current.unlockedThemes.contains(themeColor)) {
      final updatedThemes = List<int>.from(current.unlockedThemes)
        ..add(themeColor);
      final updated = current.copyWith(
        virtualCoins: current.virtualCoins - cost,
        unlockedThemes: updatedThemes,
      );
      await saveKazaData(updated);
      await InteractionService.success();
      return true;
    }
    return false;
  }

  Future<void> decrementDay() async {
    final current = getKazaData();
    // Decrement all by 1
    KazaModel updated = current.copyWith(
      fajr: (current.fajr - 1).clamp(0, 999999),
      dhuhr: (current.dhuhr - 1).clamp(0, 999999),
      asr: (current.asr - 1).clamp(0, 999999),
      maghrib: (current.maghrib - 1).clamp(0, 999999),
      isha: (current.isha - 1).clamp(0, 999999),
      witr: (current.witr - 1).clamp(0, 999999),
    );

    updated = updated.countPrayer(6); // 6 units for a full day
    await InteractionService.success();

    await saveKazaData(updated);
    await _logActivity(6);
    await _updateStreaksAndAchievements();
  }

  Future<void> setInitialData(KazaModel data) async {
    await saveKazaData(data);
  }

  bool get isFirstRun => _box.get(_key) == null;

  Future<void> _updateStreaksAndAchievements() async {
    final current = getKazaData();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Streaks logic
    int currentStreak = current.currentStreak;
    int bestStreak = current.bestStreak;
    String? lastDateStr = current.lastActivityDate;

    if (lastDateStr != null) {
      final lastDate = DateTime.parse(lastDateStr);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        // Daily activity, increment streak
        currentStreak++;
      } else if (difference > 1) {
        // Missed days, reset streak
        currentStreak = 1;
      }
      // If difference == 0, already active today, no changes
    } else {
      // First activity ever
      currentStreak = 1;
    }

    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
    }

    // Achievements logic
    final achievements = List<String>.from(current.achievements);
    final totalCompleted = current.totalInitial - current.totalRemaining;

    if (totalCompleted >= 100 && !achievements.contains('prayers100')) {
      achievements.add('prayers100');
    }
    if (totalCompleted >= 500 && !achievements.contains('prayers500')) {
      achievements.add('prayers500');
    }

    final updated = current.copyWith(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastActivityDate: today.toIso8601String(),
      achievements: achievements,
    );

    await saveKazaData(updated);
  }

  // Settings Persistence
  Future<void> saveNotificationSettings(
    bool enabled,
    int hour,
    int minute,
  ) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('notifications_enabled', enabled);
    await box.put('reminder_hour', hour);
    await box.put('reminder_minute', minute);
  }

  Future<void> saveInteractionSettings(bool sound, bool vibration) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('sound_enabled', sound);
    await box.put('vibration_enabled', vibration);
  }

  Future<void> saveThemeColor(int color) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('theme_color', color);
  }

  Future<void> saveBiometricLock(bool enabled) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('biometric_lock', enabled);
  }

  Future<void> saveReminderOffset(int minutes) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('reminder_offset', minutes);
  }

  Future<void> saveSilentHours(int start, int end) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('silent_start', start);
    await box.put('silent_end', end);
  }

  Future<void> saveDynamicThemeEnabled(bool enabled) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('use_dynamic_theme', enabled);
  }

  Future<void> saveProfile(
    String? gender,
    int? ageStartedPraying,
    String? locationName,
  ) async {
    final box = Hive.box(_settingsBoxName);
    if (gender != null) await box.put('gender', gender);
    if (ageStartedPraying != null) {
      await box.put('age_started_praying', ageStartedPraying);
    }
    if (locationName != null) await box.put('location_name', locationName);
  }

  Future<Map<String, dynamic>> getNotificationSettings() async {
    final box = Hive.box(_settingsBoxName);
    return {
      'enabled': box.get('notifications_enabled', defaultValue: false),
      'hour': box.get('reminder_hour', defaultValue: 20),
      'minute': box.get('reminder_minute', defaultValue: 0),
      'theme_color': box.get('theme_color', defaultValue: 0xFF10B981),
      'sound_enabled': box.get('sound_enabled', defaultValue: true),
      'vibration_enabled': box.get('vibration_enabled', defaultValue: true),
      'biometric_lock': box.get('biometric_lock', defaultValue: false),
      'silent_start': box.get('silent_start', defaultValue: 22),
      'silent_end': box.get('silent_end', defaultValue: 6),
      'reminder_offset': box.get('reminder_offset', defaultValue: 15),
      'use_dynamic_theme': box.get('use_dynamic_theme', defaultValue: false),
      'gender': box.get('gender'),
      'age_started_praying': box.get('age_started_praying'),
      'location_name': box.get('location_name'),
    };
  }
}
