enum PrayerType { fajr, dhuhr, asr, maghrib, isha, witr }

class KazaModel {
  final int fajr;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;
  final int witr;

  // Initial counts to calculate progress
  final int initialFajr;
  final int initialDhuhr;
  final int initialAsr;
  final int initialMaghrib;
  final int initialIsha;
  final int initialWitr;

  const KazaModel({
    this.fajr = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
    this.witr = 0,
    this.initialFajr = 0,
    this.initialDhuhr = 0,
    this.initialAsr = 0,
    this.initialMaghrib = 0,
    this.initialIsha = 0,
    this.initialWitr = 0,
  });

  KazaModel copyWith({
    int? fajr,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
    int? witr,
    int? initialFajr,
    int? initialDhuhr,
    int? initialAsr,
    int? initialMaghrib,
    int? initialIsha,
    int? initialWitr,
  }) {
    return KazaModel(
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      witr: witr ?? this.witr,
      initialFajr: initialFajr ?? this.initialFajr,
      initialDhuhr: initialDhuhr ?? this.initialDhuhr,
      initialAsr: initialAsr ?? this.initialAsr,
      initialMaghrib: initialMaghrib ?? this.initialMaghrib,
      initialIsha: initialIsha ?? this.initialIsha,
      initialWitr: initialWitr ?? this.initialWitr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'witr': witr,
      'initialFajr': initialFajr,
      'initialDhuhr': initialDhuhr,
      'initialAsr': initialAsr,
      'initialMaghrib': initialMaghrib,
      'initialIsha': initialIsha,
      'initialWitr': initialWitr,
    };
  }

  factory KazaModel.fromMap(Map<dynamic, dynamic> map) {
    return KazaModel(
      fajr: map['fajr']?.toInt() ?? 0,
      dhuhr: map['dhuhr']?.toInt() ?? 0,
      asr: map['asr']?.toInt() ?? 0,
      maghrib: map['maghrib']?.toInt() ?? 0,
      isha: map['isha']?.toInt() ?? 0,
      witr: map['witr']?.toInt() ?? 0,
      initialFajr: map['initialFajr']?.toInt() ?? 0,
      initialDhuhr: map['initialDhuhr']?.toInt() ?? 0,
      initialAsr: map['initialAsr']?.toInt() ?? 0,
      initialMaghrib: map['initialMaghrib']?.toInt() ?? 0,
      initialIsha: map['initialIsha']?.toInt() ?? 0,
      initialWitr: map['initialWitr']?.toInt() ?? 0,
    );
  }

  int get totalRemaining => fajr + dhuhr + asr + maghrib + isha + witr;
  int get totalInitial =>
      initialFajr +
      initialDhuhr +
      initialAsr +
      initialMaghrib +
      initialIsha +
      initialWitr;

  double get progress {
    if (totalInitial == 0) return 0;
    return 1 - (totalRemaining / totalInitial);
  }

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
    }
  }
}
