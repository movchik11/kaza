// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kaza_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KazaModelImpl _$$KazaModelImplFromJson(Map<String, dynamic> json) =>
    _$KazaModelImpl(
      fajr: (json['fajr'] as num?)?.toInt() ?? 0,
      dhuhr: (json['dhuhr'] as num?)?.toInt() ?? 0,
      asr: (json['asr'] as num?)?.toInt() ?? 0,
      maghrib: (json['maghrib'] as num?)?.toInt() ?? 0,
      isha: (json['isha'] as num?)?.toInt() ?? 0,
      witr: (json['witr'] as num?)?.toInt() ?? 0,
      fasting: (json['fasting'] as num?)?.toInt() ?? 0,
      sunnahFajr: (json['sunnahFajr'] as num?)?.toInt() ?? 0,
      sunnahDhuhr: (json['sunnahDhuhr'] as num?)?.toInt() ?? 0,
      sunnahAsr: (json['sunnahAsr'] as num?)?.toInt() ?? 0,
      sunnahMaghrib: (json['sunnahMaghrib'] as num?)?.toInt() ?? 0,
      sunnahIsha: (json['sunnahIsha'] as num?)?.toInt() ?? 0,
      nafl: (json['nafl'] as num?)?.toInt() ?? 0,
      initialFajr: (json['initialFajr'] as num?)?.toInt() ?? 0,
      initialDhuhr: (json['initialDhuhr'] as num?)?.toInt() ?? 0,
      initialAsr: (json['initialAsr'] as num?)?.toInt() ?? 0,
      initialMaghrib: (json['initialMaghrib'] as num?)?.toInt() ?? 0,
      initialIsha: (json['initialIsha'] as num?)?.toInt() ?? 0,
      initialWitr: (json['initialWitr'] as num?)?.toInt() ?? 0,
      initialFasting: (json['initialFasting'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      lastActivityDate: json['lastActivityDate'] as String?,
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      level: (json['level'] as num?)?.toInt() ?? 1,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      virtualCoins: (json['virtualCoins'] as num?)?.toInt() ?? 0,
      dailyGoal: (json['dailyGoal'] as num?)?.toInt() ?? 5,
      completedToday: (json['completedToday'] as num?)?.toInt() ?? 0,
      lastDailyReset: json['lastDailyReset'] as String?,
      lastQuranSurah: (json['lastQuranSurah'] as num?)?.toInt() ?? 1,
      lastQuranPage: (json['lastQuranPage'] as num?)?.toInt() ?? 1,
      unlockedThemes:
          (json['unlockedThemes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$KazaModelImplToJson(_$KazaModelImpl instance) =>
    <String, dynamic>{
      'fajr': instance.fajr,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
      'witr': instance.witr,
      'fasting': instance.fasting,
      'sunnahFajr': instance.sunnahFajr,
      'sunnahDhuhr': instance.sunnahDhuhr,
      'sunnahAsr': instance.sunnahAsr,
      'sunnahMaghrib': instance.sunnahMaghrib,
      'sunnahIsha': instance.sunnahIsha,
      'nafl': instance.nafl,
      'initialFajr': instance.initialFajr,
      'initialDhuhr': instance.initialDhuhr,
      'initialAsr': instance.initialAsr,
      'initialMaghrib': instance.initialMaghrib,
      'initialIsha': instance.initialIsha,
      'initialWitr': instance.initialWitr,
      'initialFasting': instance.initialFasting,
      'currentStreak': instance.currentStreak,
      'bestStreak': instance.bestStreak,
      'lastActivityDate': instance.lastActivityDate,
      'achievements': instance.achievements,
      'level': instance.level,
      'exp': instance.exp,
      'virtualCoins': instance.virtualCoins,
      'dailyGoal': instance.dailyGoal,
      'completedToday': instance.completedToday,
      'lastDailyReset': instance.lastDailyReset,
      'lastQuranSurah': instance.lastQuranSurah,
      'lastQuranPage': instance.lastQuranPage,
      'unlockedThemes': instance.unlockedThemes,
    };
