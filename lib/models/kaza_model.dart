import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'kaza_model.freezed.dart';
part 'kaza_model.g.dart';

enum PrayerType { fajr, dhuhr, asr, maghrib, isha, witr, fasting }

@freezed
class KazaModel with _$KazaModel {
  const factory KazaModel({
    @Default(0) int fajr,
    @Default(0) int dhuhr,
    @Default(0) int asr,
    @Default(0) int maghrib,
    @Default(0) int isha,
    @Default(0) int witr,
    @Default(0) int fasting,

    // Sunnah & Nafl (Daily counts)
    @Default(0) int sunnahFajr,
    @Default(0) int sunnahDhuhr,
    @Default(0) int sunnahAsr,
    @Default(0) int sunnahMaghrib,
    @Default(0) int sunnahIsha,
    @Default(0) int nafl,

    // Initial counts to calculate progress
    @Default(0) int initialFajr,
    @Default(0) int initialDhuhr,
    @Default(0) int initialAsr,
    @Default(0) int initialMaghrib,
    @Default(0) int initialIsha,
    @Default(0) int initialWitr,
    @Default(0) int initialFasting,

    @Default(0) int currentStreak,
    @Default(0) int bestStreak,
    String? lastActivityDate, // Store as ISO string
    @Default([]) List<String> achievements,

    // Gamification & Goals
    @Default(1) int level,
    @Default(0) int exp,
    @Default(0) int virtualCoins,
    @Default(5) int dailyGoal,
    @Default(0) int completedToday,
    String? lastDailyReset, // Store as ISO string
    // Quran Progress
    @Default(1) int lastQuranSurah,
    @Default(1) int lastQuranPage,
    @Default([]) List<int> unlockedThemes,
  }) = _KazaModel;

  // ignore: unused_element
  const KazaModel._();

  factory KazaModel.fromJson(Map<String, dynamic> json) =>
      _$KazaModelFromJson(json);

  // Hive stores Map<dynamic, dynamic>, so we need a converter or fromMap
  factory KazaModel.fromMap(Map<dynamic, dynamic> map) {
    final stringMap = map.map((key, value) => MapEntry(key.toString(), value));
    return KazaModel.fromJson(stringMap);
  }
}

extension KazaModelX on KazaModel {
  Map<String, dynamic> toMap() => toJson();

  int get totalRemaining =>
      fajr + dhuhr + asr + maghrib + isha + witr + fasting;

  int get totalInitial =>
      initialFajr +
      initialDhuhr +
      initialAsr +
      initialMaghrib +
      initialIsha +
      initialWitr +
      initialFasting;

  double get progress {
    if (totalInitial == 0) return 0;
    return 1 - (totalRemaining / totalInitial);
  }

  int get totalCompleted => totalInitial - totalRemaining;

  int getCount(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return fajr;
      case PrayerType.dhuhr:
        return dhuhr;
      case PrayerType.asr:
        return asr;
      case PrayerType.maghrib:
        return maghrib;
      case PrayerType.isha:
        return isha;
      case PrayerType.witr:
        return witr;
      case PrayerType.fasting:
        return fasting;
    }
  }

  /// Calculates XP needed for next level: Lvl * 100
  int get xpForNextLevel => level * 100;

  /// Check if daily goals should be reset
  KazaModel resetIfNeeded() {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    if (lastDailyReset != todayStr) {
      return copyWith(completedToday: 0, lastDailyReset: todayStr);
    }
    return this;
  }

  /// Increment stats after completing a prayer
  KazaModel countPrayer(int amount) {
    int newExp = exp + (amount * 10); // 10 XP per prayer unit
    int newLevel = level;

    // Level up logic
    while (newExp >= (newLevel * 100)) {
      newExp -= (newLevel * 100);
      newLevel++;
    }

    return copyWith(
      exp: newExp,
      level: newLevel,
      completedToday: completedToday + amount,
    ).checkAchievements();
  }

  /// Automatically check and unlock achievements
  KazaModel checkAchievements() {
    final newAchievements = List<String>.from(achievements);
    final total = totalCompleted;

    void addIfNew(String id) {
      if (!newAchievements.contains(id)) {
        newAchievements.add(id);
      }
    }

    if (total >= 100) addIfNew('prayers100');
    if (total >= 500) addIfNew('prayers500');
    if (total >= 1000) addIfNew('prayers1000');
    if (level >= 10) addIfNew('level10');
    if (level >= 25) addIfNew('level25');
    if (currentStreak >= 7) addIfNew('streak7');
    if (currentStreak >= 30) addIfNew('streak30');
    if (completedToday >= dailyGoal) addIfNew('dailyGoalMet');

    if (newAchievements.length == achievements.length) return this;
    return copyWith(achievements: newAchievements);
  }

  /// Gets rank name based on level
  String get rankName {
    if (level < 5) return 'Beginner';
    if (level < 15) return 'Diligent';
    if (level < 30) return 'Devoted';
    if (level < 50) return 'Master';
    return 'Legend';
  }

  /// Gets rank icon based on level
  IconData get rankIcon {
    if (level < 5) return Icons.star_border_rounded;
    if (level < 15) return Icons.star_half_rounded;
    if (level < 30) return Icons.star_rounded;
    if (level < 50) return Icons.workspace_premium_rounded;
    return Icons.military_tech_rounded;
  }
}
