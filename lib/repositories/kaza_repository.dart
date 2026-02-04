import 'package:hive_flutter/hive_flutter.dart';
import '../models/kaza_model.dart';

class KazaRepository {
  static const String _boxName = 'kaza_box';
  static const String _historyBoxName = 'kaza_history_box';
  static const String _key = 'user_kaza';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
    await Hive.openBox<int>(_historyBoxName);
  }

  Box get _box => Hive.box(_boxName);
  Box<int> get _historyBox => Hive.box<int>(_historyBoxName);

  KazaModel getKazaData() {
    final data = _box.get(_key);
    if (data == null) {
      return const KazaModel();
    }
    // Hive stores Map<dynamic, dynamic> by default
    return KazaModel.fromMap(Map<dynamic, dynamic>.from(data));
  }

  Future<void> saveKazaData(KazaModel data) async {
    await _box.put(_key, data.toMap());
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

    await saveKazaData(updated);
    await _logActivity(amount);
  }

  Future<void> decrementDay() async {
    final current = getKazaData();
    // Decrement all by 1
    final updated = current.copyWith(
      fajr: (current.fajr - 1).clamp(0, 999999),
      dhuhr: (current.dhuhr - 1).clamp(0, 999999),
      asr: (current.asr - 1).clamp(0, 999999),
      maghrib: (current.maghrib - 1).clamp(0, 999999),
      isha: (current.isha - 1).clamp(0, 999999),
      witr: (current.witr - 1).clamp(0, 999999),
    );

    await saveKazaData(updated);
    await _logActivity(6);
  }

  Future<void> setInitialData(KazaModel data) async {
    await saveKazaData(data);
  }

  bool get isFirstRun => _box.get(_key) == null;

  // Settings Persistence
  static const String _settingsBoxName = 'settings_box';

  Future<void> saveNotificationSettings(
    bool enabled,
    int hour,
    int minute,
  ) async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.put('notifications_enabled', enabled);
    await box.put('reminder_hour', hour);
    await box.put('reminder_minute', minute);
  }

  Future<Map<String, dynamic>> getNotificationSettings() async {
    final box = await Hive.openBox(_settingsBoxName);
    return {
      'enabled': box.get('notifications_enabled', defaultValue: false),
      'hour': box.get('reminder_hour', defaultValue: 20),
      'minute': box.get('reminder_minute', defaultValue: 0),
    };
  }
}
