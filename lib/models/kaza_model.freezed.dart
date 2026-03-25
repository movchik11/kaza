// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kaza_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KazaModel _$KazaModelFromJson(Map<String, dynamic> json) {
  return _KazaModel.fromJson(json);
}

/// @nodoc
mixin _$KazaModel {
  int get fajr => throw _privateConstructorUsedError;
  int get dhuhr => throw _privateConstructorUsedError;
  int get asr => throw _privateConstructorUsedError;
  int get maghrib => throw _privateConstructorUsedError;
  int get isha => throw _privateConstructorUsedError;
  int get witr => throw _privateConstructorUsedError;
  int get fasting =>
      throw _privateConstructorUsedError; // Sunnah & Nafl (Daily counts)
  int get sunnahFajr => throw _privateConstructorUsedError;
  int get sunnahDhuhr => throw _privateConstructorUsedError;
  int get sunnahAsr => throw _privateConstructorUsedError;
  int get sunnahMaghrib => throw _privateConstructorUsedError;
  int get sunnahIsha => throw _privateConstructorUsedError;
  int get nafl =>
      throw _privateConstructorUsedError; // Initial counts to calculate progress
  int get initialFajr => throw _privateConstructorUsedError;
  int get initialDhuhr => throw _privateConstructorUsedError;
  int get initialAsr => throw _privateConstructorUsedError;
  int get initialMaghrib => throw _privateConstructorUsedError;
  int get initialIsha => throw _privateConstructorUsedError;
  int get initialWitr => throw _privateConstructorUsedError;
  int get initialFasting => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get bestStreak => throw _privateConstructorUsedError;
  String? get lastActivityDate =>
      throw _privateConstructorUsedError; // Store as ISO string
  List<String> get achievements =>
      throw _privateConstructorUsedError; // Gamification & Goals
  int get level => throw _privateConstructorUsedError;
  int get exp => throw _privateConstructorUsedError;
  int get virtualCoins => throw _privateConstructorUsedError;
  int get dailyGoal => throw _privateConstructorUsedError;
  int get completedToday => throw _privateConstructorUsedError;
  String? get lastDailyReset =>
      throw _privateConstructorUsedError; // Store as ISO string
  // Quran Progress
  int get lastQuranSurah => throw _privateConstructorUsedError;
  int get lastQuranPage => throw _privateConstructorUsedError;
  List<int> get unlockedThemes => throw _privateConstructorUsedError;

  /// Serializes this KazaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KazaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KazaModelCopyWith<KazaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KazaModelCopyWith<$Res> {
  factory $KazaModelCopyWith(KazaModel value, $Res Function(KazaModel) then) =
      _$KazaModelCopyWithImpl<$Res, KazaModel>;
  @useResult
  $Res call({
    int fajr,
    int dhuhr,
    int asr,
    int maghrib,
    int isha,
    int witr,
    int fasting,
    int sunnahFajr,
    int sunnahDhuhr,
    int sunnahAsr,
    int sunnahMaghrib,
    int sunnahIsha,
    int nafl,
    int initialFajr,
    int initialDhuhr,
    int initialAsr,
    int initialMaghrib,
    int initialIsha,
    int initialWitr,
    int initialFasting,
    int currentStreak,
    int bestStreak,
    String? lastActivityDate,
    List<String> achievements,
    int level,
    int exp,
    int virtualCoins,
    int dailyGoal,
    int completedToday,
    String? lastDailyReset,
    int lastQuranSurah,
    int lastQuranPage,
    List<int> unlockedThemes,
  });
}

/// @nodoc
class _$KazaModelCopyWithImpl<$Res, $Val extends KazaModel>
    implements $KazaModelCopyWith<$Res> {
  _$KazaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KazaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fajr = null,
    Object? dhuhr = null,
    Object? asr = null,
    Object? maghrib = null,
    Object? isha = null,
    Object? witr = null,
    Object? fasting = null,
    Object? sunnahFajr = null,
    Object? sunnahDhuhr = null,
    Object? sunnahAsr = null,
    Object? sunnahMaghrib = null,
    Object? sunnahIsha = null,
    Object? nafl = null,
    Object? initialFajr = null,
    Object? initialDhuhr = null,
    Object? initialAsr = null,
    Object? initialMaghrib = null,
    Object? initialIsha = null,
    Object? initialWitr = null,
    Object? initialFasting = null,
    Object? currentStreak = null,
    Object? bestStreak = null,
    Object? lastActivityDate = freezed,
    Object? achievements = null,
    Object? level = null,
    Object? exp = null,
    Object? virtualCoins = null,
    Object? dailyGoal = null,
    Object? completedToday = null,
    Object? lastDailyReset = freezed,
    Object? lastQuranSurah = null,
    Object? lastQuranPage = null,
    Object? unlockedThemes = null,
  }) {
    return _then(
      _value.copyWith(
            fajr: null == fajr
                ? _value.fajr
                : fajr // ignore: cast_nullable_to_non_nullable
                      as int,
            dhuhr: null == dhuhr
                ? _value.dhuhr
                : dhuhr // ignore: cast_nullable_to_non_nullable
                      as int,
            asr: null == asr
                ? _value.asr
                : asr // ignore: cast_nullable_to_non_nullable
                      as int,
            maghrib: null == maghrib
                ? _value.maghrib
                : maghrib // ignore: cast_nullable_to_non_nullable
                      as int,
            isha: null == isha
                ? _value.isha
                : isha // ignore: cast_nullable_to_non_nullable
                      as int,
            witr: null == witr
                ? _value.witr
                : witr // ignore: cast_nullable_to_non_nullable
                      as int,
            fasting: null == fasting
                ? _value.fasting
                : fasting // ignore: cast_nullable_to_non_nullable
                      as int,
            sunnahFajr: null == sunnahFajr
                ? _value.sunnahFajr
                : sunnahFajr // ignore: cast_nullable_to_non_nullable
                      as int,
            sunnahDhuhr: null == sunnahDhuhr
                ? _value.sunnahDhuhr
                : sunnahDhuhr // ignore: cast_nullable_to_non_nullable
                      as int,
            sunnahAsr: null == sunnahAsr
                ? _value.sunnahAsr
                : sunnahAsr // ignore: cast_nullable_to_non_nullable
                      as int,
            sunnahMaghrib: null == sunnahMaghrib
                ? _value.sunnahMaghrib
                : sunnahMaghrib // ignore: cast_nullable_to_non_nullable
                      as int,
            sunnahIsha: null == sunnahIsha
                ? _value.sunnahIsha
                : sunnahIsha // ignore: cast_nullable_to_non_nullable
                      as int,
            nafl: null == nafl
                ? _value.nafl
                : nafl // ignore: cast_nullable_to_non_nullable
                      as int,
            initialFajr: null == initialFajr
                ? _value.initialFajr
                : initialFajr // ignore: cast_nullable_to_non_nullable
                      as int,
            initialDhuhr: null == initialDhuhr
                ? _value.initialDhuhr
                : initialDhuhr // ignore: cast_nullable_to_non_nullable
                      as int,
            initialAsr: null == initialAsr
                ? _value.initialAsr
                : initialAsr // ignore: cast_nullable_to_non_nullable
                      as int,
            initialMaghrib: null == initialMaghrib
                ? _value.initialMaghrib
                : initialMaghrib // ignore: cast_nullable_to_non_nullable
                      as int,
            initialIsha: null == initialIsha
                ? _value.initialIsha
                : initialIsha // ignore: cast_nullable_to_non_nullable
                      as int,
            initialWitr: null == initialWitr
                ? _value.initialWitr
                : initialWitr // ignore: cast_nullable_to_non_nullable
                      as int,
            initialFasting: null == initialFasting
                ? _value.initialFasting
                : initialFasting // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            bestStreak: null == bestStreak
                ? _value.bestStreak
                : bestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActivityDate: freezed == lastActivityDate
                ? _value.lastActivityDate
                : lastActivityDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            achievements: null == achievements
                ? _value.achievements
                : achievements // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            exp: null == exp
                ? _value.exp
                : exp // ignore: cast_nullable_to_non_nullable
                      as int,
            virtualCoins: null == virtualCoins
                ? _value.virtualCoins
                : virtualCoins // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyGoal: null == dailyGoal
                ? _value.dailyGoal
                : dailyGoal // ignore: cast_nullable_to_non_nullable
                      as int,
            completedToday: null == completedToday
                ? _value.completedToday
                : completedToday // ignore: cast_nullable_to_non_nullable
                      as int,
            lastDailyReset: freezed == lastDailyReset
                ? _value.lastDailyReset
                : lastDailyReset // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastQuranSurah: null == lastQuranSurah
                ? _value.lastQuranSurah
                : lastQuranSurah // ignore: cast_nullable_to_non_nullable
                      as int,
            lastQuranPage: null == lastQuranPage
                ? _value.lastQuranPage
                : lastQuranPage // ignore: cast_nullable_to_non_nullable
                      as int,
            unlockedThemes: null == unlockedThemes
                ? _value.unlockedThemes
                : unlockedThemes // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KazaModelImplCopyWith<$Res>
    implements $KazaModelCopyWith<$Res> {
  factory _$$KazaModelImplCopyWith(
    _$KazaModelImpl value,
    $Res Function(_$KazaModelImpl) then,
  ) = __$$KazaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int fajr,
    int dhuhr,
    int asr,
    int maghrib,
    int isha,
    int witr,
    int fasting,
    int sunnahFajr,
    int sunnahDhuhr,
    int sunnahAsr,
    int sunnahMaghrib,
    int sunnahIsha,
    int nafl,
    int initialFajr,
    int initialDhuhr,
    int initialAsr,
    int initialMaghrib,
    int initialIsha,
    int initialWitr,
    int initialFasting,
    int currentStreak,
    int bestStreak,
    String? lastActivityDate,
    List<String> achievements,
    int level,
    int exp,
    int virtualCoins,
    int dailyGoal,
    int completedToday,
    String? lastDailyReset,
    int lastQuranSurah,
    int lastQuranPage,
    List<int> unlockedThemes,
  });
}

/// @nodoc
class __$$KazaModelImplCopyWithImpl<$Res>
    extends _$KazaModelCopyWithImpl<$Res, _$KazaModelImpl>
    implements _$$KazaModelImplCopyWith<$Res> {
  __$$KazaModelImplCopyWithImpl(
    _$KazaModelImpl _value,
    $Res Function(_$KazaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KazaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fajr = null,
    Object? dhuhr = null,
    Object? asr = null,
    Object? maghrib = null,
    Object? isha = null,
    Object? witr = null,
    Object? fasting = null,
    Object? sunnahFajr = null,
    Object? sunnahDhuhr = null,
    Object? sunnahAsr = null,
    Object? sunnahMaghrib = null,
    Object? sunnahIsha = null,
    Object? nafl = null,
    Object? initialFajr = null,
    Object? initialDhuhr = null,
    Object? initialAsr = null,
    Object? initialMaghrib = null,
    Object? initialIsha = null,
    Object? initialWitr = null,
    Object? initialFasting = null,
    Object? currentStreak = null,
    Object? bestStreak = null,
    Object? lastActivityDate = freezed,
    Object? achievements = null,
    Object? level = null,
    Object? exp = null,
    Object? virtualCoins = null,
    Object? dailyGoal = null,
    Object? completedToday = null,
    Object? lastDailyReset = freezed,
    Object? lastQuranSurah = null,
    Object? lastQuranPage = null,
    Object? unlockedThemes = null,
  }) {
    return _then(
      _$KazaModelImpl(
        fajr: null == fajr
            ? _value.fajr
            : fajr // ignore: cast_nullable_to_non_nullable
                  as int,
        dhuhr: null == dhuhr
            ? _value.dhuhr
            : dhuhr // ignore: cast_nullable_to_non_nullable
                  as int,
        asr: null == asr
            ? _value.asr
            : asr // ignore: cast_nullable_to_non_nullable
                  as int,
        maghrib: null == maghrib
            ? _value.maghrib
            : maghrib // ignore: cast_nullable_to_non_nullable
                  as int,
        isha: null == isha
            ? _value.isha
            : isha // ignore: cast_nullable_to_non_nullable
                  as int,
        witr: null == witr
            ? _value.witr
            : witr // ignore: cast_nullable_to_non_nullable
                  as int,
        fasting: null == fasting
            ? _value.fasting
            : fasting // ignore: cast_nullable_to_non_nullable
                  as int,
        sunnahFajr: null == sunnahFajr
            ? _value.sunnahFajr
            : sunnahFajr // ignore: cast_nullable_to_non_nullable
                  as int,
        sunnahDhuhr: null == sunnahDhuhr
            ? _value.sunnahDhuhr
            : sunnahDhuhr // ignore: cast_nullable_to_non_nullable
                  as int,
        sunnahAsr: null == sunnahAsr
            ? _value.sunnahAsr
            : sunnahAsr // ignore: cast_nullable_to_non_nullable
                  as int,
        sunnahMaghrib: null == sunnahMaghrib
            ? _value.sunnahMaghrib
            : sunnahMaghrib // ignore: cast_nullable_to_non_nullable
                  as int,
        sunnahIsha: null == sunnahIsha
            ? _value.sunnahIsha
            : sunnahIsha // ignore: cast_nullable_to_non_nullable
                  as int,
        nafl: null == nafl
            ? _value.nafl
            : nafl // ignore: cast_nullable_to_non_nullable
                  as int,
        initialFajr: null == initialFajr
            ? _value.initialFajr
            : initialFajr // ignore: cast_nullable_to_non_nullable
                  as int,
        initialDhuhr: null == initialDhuhr
            ? _value.initialDhuhr
            : initialDhuhr // ignore: cast_nullable_to_non_nullable
                  as int,
        initialAsr: null == initialAsr
            ? _value.initialAsr
            : initialAsr // ignore: cast_nullable_to_non_nullable
                  as int,
        initialMaghrib: null == initialMaghrib
            ? _value.initialMaghrib
            : initialMaghrib // ignore: cast_nullable_to_non_nullable
                  as int,
        initialIsha: null == initialIsha
            ? _value.initialIsha
            : initialIsha // ignore: cast_nullable_to_non_nullable
                  as int,
        initialWitr: null == initialWitr
            ? _value.initialWitr
            : initialWitr // ignore: cast_nullable_to_non_nullable
                  as int,
        initialFasting: null == initialFasting
            ? _value.initialFasting
            : initialFasting // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        bestStreak: null == bestStreak
            ? _value.bestStreak
            : bestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActivityDate: freezed == lastActivityDate
            ? _value.lastActivityDate
            : lastActivityDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        achievements: null == achievements
            ? _value._achievements
            : achievements // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        exp: null == exp
            ? _value.exp
            : exp // ignore: cast_nullable_to_non_nullable
                  as int,
        virtualCoins: null == virtualCoins
            ? _value.virtualCoins
            : virtualCoins // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyGoal: null == dailyGoal
            ? _value.dailyGoal
            : dailyGoal // ignore: cast_nullable_to_non_nullable
                  as int,
        completedToday: null == completedToday
            ? _value.completedToday
            : completedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        lastDailyReset: freezed == lastDailyReset
            ? _value.lastDailyReset
            : lastDailyReset // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastQuranSurah: null == lastQuranSurah
            ? _value.lastQuranSurah
            : lastQuranSurah // ignore: cast_nullable_to_non_nullable
                  as int,
        lastQuranPage: null == lastQuranPage
            ? _value.lastQuranPage
            : lastQuranPage // ignore: cast_nullable_to_non_nullable
                  as int,
        unlockedThemes: null == unlockedThemes
            ? _value._unlockedThemes
            : unlockedThemes // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KazaModelImpl extends _KazaModel {
  const _$KazaModelImpl({
    this.fajr = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
    this.witr = 0,
    this.fasting = 0,
    this.sunnahFajr = 0,
    this.sunnahDhuhr = 0,
    this.sunnahAsr = 0,
    this.sunnahMaghrib = 0,
    this.sunnahIsha = 0,
    this.nafl = 0,
    this.initialFajr = 0,
    this.initialDhuhr = 0,
    this.initialAsr = 0,
    this.initialMaghrib = 0,
    this.initialIsha = 0,
    this.initialWitr = 0,
    this.initialFasting = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActivityDate,
    final List<String> achievements = const [],
    this.level = 1,
    this.exp = 0,
    this.virtualCoins = 0,
    this.dailyGoal = 5,
    this.completedToday = 0,
    this.lastDailyReset,
    this.lastQuranSurah = 1,
    this.lastQuranPage = 1,
    final List<int> unlockedThemes = const [],
  }) : _achievements = achievements,
       _unlockedThemes = unlockedThemes,
       super._();

  factory _$KazaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KazaModelImplFromJson(json);

  @override
  @JsonKey()
  final int fajr;
  @override
  @JsonKey()
  final int dhuhr;
  @override
  @JsonKey()
  final int asr;
  @override
  @JsonKey()
  final int maghrib;
  @override
  @JsonKey()
  final int isha;
  @override
  @JsonKey()
  final int witr;
  @override
  @JsonKey()
  final int fasting;
  // Sunnah & Nafl (Daily counts)
  @override
  @JsonKey()
  final int sunnahFajr;
  @override
  @JsonKey()
  final int sunnahDhuhr;
  @override
  @JsonKey()
  final int sunnahAsr;
  @override
  @JsonKey()
  final int sunnahMaghrib;
  @override
  @JsonKey()
  final int sunnahIsha;
  @override
  @JsonKey()
  final int nafl;
  // Initial counts to calculate progress
  @override
  @JsonKey()
  final int initialFajr;
  @override
  @JsonKey()
  final int initialDhuhr;
  @override
  @JsonKey()
  final int initialAsr;
  @override
  @JsonKey()
  final int initialMaghrib;
  @override
  @JsonKey()
  final int initialIsha;
  @override
  @JsonKey()
  final int initialWitr;
  @override
  @JsonKey()
  final int initialFasting;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int bestStreak;
  @override
  final String? lastActivityDate;
  // Store as ISO string
  final List<String> _achievements;
  // Store as ISO string
  @override
  @JsonKey()
  List<String> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  // Gamification & Goals
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int exp;
  @override
  @JsonKey()
  final int virtualCoins;
  @override
  @JsonKey()
  final int dailyGoal;
  @override
  @JsonKey()
  final int completedToday;
  @override
  final String? lastDailyReset;
  // Store as ISO string
  // Quran Progress
  @override
  @JsonKey()
  final int lastQuranSurah;
  @override
  @JsonKey()
  final int lastQuranPage;
  final List<int> _unlockedThemes;
  @override
  @JsonKey()
  List<int> get unlockedThemes {
    if (_unlockedThemes is EqualUnmodifiableListView) return _unlockedThemes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedThemes);
  }

  @override
  String toString() {
    return 'KazaModel(fajr: $fajr, dhuhr: $dhuhr, asr: $asr, maghrib: $maghrib, isha: $isha, witr: $witr, fasting: $fasting, sunnahFajr: $sunnahFajr, sunnahDhuhr: $sunnahDhuhr, sunnahAsr: $sunnahAsr, sunnahMaghrib: $sunnahMaghrib, sunnahIsha: $sunnahIsha, nafl: $nafl, initialFajr: $initialFajr, initialDhuhr: $initialDhuhr, initialAsr: $initialAsr, initialMaghrib: $initialMaghrib, initialIsha: $initialIsha, initialWitr: $initialWitr, initialFasting: $initialFasting, currentStreak: $currentStreak, bestStreak: $bestStreak, lastActivityDate: $lastActivityDate, achievements: $achievements, level: $level, exp: $exp, virtualCoins: $virtualCoins, dailyGoal: $dailyGoal, completedToday: $completedToday, lastDailyReset: $lastDailyReset, lastQuranSurah: $lastQuranSurah, lastQuranPage: $lastQuranPage, unlockedThemes: $unlockedThemes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KazaModelImpl &&
            (identical(other.fajr, fajr) || other.fajr == fajr) &&
            (identical(other.dhuhr, dhuhr) || other.dhuhr == dhuhr) &&
            (identical(other.asr, asr) || other.asr == asr) &&
            (identical(other.maghrib, maghrib) || other.maghrib == maghrib) &&
            (identical(other.isha, isha) || other.isha == isha) &&
            (identical(other.witr, witr) || other.witr == witr) &&
            (identical(other.fasting, fasting) || other.fasting == fasting) &&
            (identical(other.sunnahFajr, sunnahFajr) ||
                other.sunnahFajr == sunnahFajr) &&
            (identical(other.sunnahDhuhr, sunnahDhuhr) ||
                other.sunnahDhuhr == sunnahDhuhr) &&
            (identical(other.sunnahAsr, sunnahAsr) ||
                other.sunnahAsr == sunnahAsr) &&
            (identical(other.sunnahMaghrib, sunnahMaghrib) ||
                other.sunnahMaghrib == sunnahMaghrib) &&
            (identical(other.sunnahIsha, sunnahIsha) ||
                other.sunnahIsha == sunnahIsha) &&
            (identical(other.nafl, nafl) || other.nafl == nafl) &&
            (identical(other.initialFajr, initialFajr) ||
                other.initialFajr == initialFajr) &&
            (identical(other.initialDhuhr, initialDhuhr) ||
                other.initialDhuhr == initialDhuhr) &&
            (identical(other.initialAsr, initialAsr) ||
                other.initialAsr == initialAsr) &&
            (identical(other.initialMaghrib, initialMaghrib) ||
                other.initialMaghrib == initialMaghrib) &&
            (identical(other.initialIsha, initialIsha) ||
                other.initialIsha == initialIsha) &&
            (identical(other.initialWitr, initialWitr) ||
                other.initialWitr == initialWitr) &&
            (identical(other.initialFasting, initialFasting) ||
                other.initialFasting == initialFasting) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.bestStreak, bestStreak) ||
                other.bestStreak == bestStreak) &&
            (identical(other.lastActivityDate, lastActivityDate) ||
                other.lastActivityDate == lastActivityDate) &&
            const DeepCollectionEquality().equals(
              other._achievements,
              _achievements,
            ) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.exp, exp) || other.exp == exp) &&
            (identical(other.virtualCoins, virtualCoins) ||
                other.virtualCoins == virtualCoins) &&
            (identical(other.dailyGoal, dailyGoal) ||
                other.dailyGoal == dailyGoal) &&
            (identical(other.completedToday, completedToday) ||
                other.completedToday == completedToday) &&
            (identical(other.lastDailyReset, lastDailyReset) ||
                other.lastDailyReset == lastDailyReset) &&
            (identical(other.lastQuranSurah, lastQuranSurah) ||
                other.lastQuranSurah == lastQuranSurah) &&
            (identical(other.lastQuranPage, lastQuranPage) ||
                other.lastQuranPage == lastQuranPage) &&
            const DeepCollectionEquality().equals(
              other._unlockedThemes,
              _unlockedThemes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    witr,
    fasting,
    sunnahFajr,
    sunnahDhuhr,
    sunnahAsr,
    sunnahMaghrib,
    sunnahIsha,
    nafl,
    initialFajr,
    initialDhuhr,
    initialAsr,
    initialMaghrib,
    initialIsha,
    initialWitr,
    initialFasting,
    currentStreak,
    bestStreak,
    lastActivityDate,
    const DeepCollectionEquality().hash(_achievements),
    level,
    exp,
    virtualCoins,
    dailyGoal,
    completedToday,
    lastDailyReset,
    lastQuranSurah,
    lastQuranPage,
    const DeepCollectionEquality().hash(_unlockedThemes),
  ]);

  /// Create a copy of KazaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KazaModelImplCopyWith<_$KazaModelImpl> get copyWith =>
      __$$KazaModelImplCopyWithImpl<_$KazaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KazaModelImplToJson(this);
  }
}

abstract class _KazaModel extends KazaModel {
  const factory _KazaModel({
    final int fajr,
    final int dhuhr,
    final int asr,
    final int maghrib,
    final int isha,
    final int witr,
    final int fasting,
    final int sunnahFajr,
    final int sunnahDhuhr,
    final int sunnahAsr,
    final int sunnahMaghrib,
    final int sunnahIsha,
    final int nafl,
    final int initialFajr,
    final int initialDhuhr,
    final int initialAsr,
    final int initialMaghrib,
    final int initialIsha,
    final int initialWitr,
    final int initialFasting,
    final int currentStreak,
    final int bestStreak,
    final String? lastActivityDate,
    final List<String> achievements,
    final int level,
    final int exp,
    final int virtualCoins,
    final int dailyGoal,
    final int completedToday,
    final String? lastDailyReset,
    final int lastQuranSurah,
    final int lastQuranPage,
    final List<int> unlockedThemes,
  }) = _$KazaModelImpl;
  const _KazaModel._() : super._();

  factory _KazaModel.fromJson(Map<String, dynamic> json) =
      _$KazaModelImpl.fromJson;

  @override
  int get fajr;
  @override
  int get dhuhr;
  @override
  int get asr;
  @override
  int get maghrib;
  @override
  int get isha;
  @override
  int get witr;
  @override
  int get fasting; // Sunnah & Nafl (Daily counts)
  @override
  int get sunnahFajr;
  @override
  int get sunnahDhuhr;
  @override
  int get sunnahAsr;
  @override
  int get sunnahMaghrib;
  @override
  int get sunnahIsha;
  @override
  int get nafl; // Initial counts to calculate progress
  @override
  int get initialFajr;
  @override
  int get initialDhuhr;
  @override
  int get initialAsr;
  @override
  int get initialMaghrib;
  @override
  int get initialIsha;
  @override
  int get initialWitr;
  @override
  int get initialFasting;
  @override
  int get currentStreak;
  @override
  int get bestStreak;
  @override
  String? get lastActivityDate; // Store as ISO string
  @override
  List<String> get achievements; // Gamification & Goals
  @override
  int get level;
  @override
  int get exp;
  @override
  int get virtualCoins;
  @override
  int get dailyGoal;
  @override
  int get completedToday;
  @override
  String? get lastDailyReset; // Store as ISO string
  // Quran Progress
  @override
  int get lastQuranSurah;
  @override
  int get lastQuranPage;
  @override
  List<int> get unlockedThemes;

  /// Create a copy of KazaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KazaModelImplCopyWith<_$KazaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
