// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SettingsState {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  int get reminderHour => throw _privateConstructorUsedError;
  int get reminderMinute => throw _privateConstructorUsedError;
  int get seedColor =>
      throw _privateConstructorUsedError; // Default Islamic Green
  bool get soundEnabled => throw _privateConstructorUsedError;
  bool get vibrationEnabled => throw _privateConstructorUsedError;
  bool get biometricLockEnabled => throw _privateConstructorUsedError;
  int get silentHoursStart => throw _privateConstructorUsedError; // 10 PM
  int get silentHoursEnd => throw _privateConstructorUsedError; // 6 AM
  int get reminderOffset =>
      throw _privateConstructorUsedError; // 15 mins before
  bool get useDynamicTheme => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  int? get ageStartedPraying => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
    SettingsState value,
    $Res Function(SettingsState) then,
  ) = _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({
    ThemeMode themeMode,
    bool notificationsEnabled,
    int reminderHour,
    int reminderMinute,
    int seedColor,
    bool soundEnabled,
    bool vibrationEnabled,
    bool biometricLockEnabled,
    int silentHoursStart,
    int silentHoursEnd,
    int reminderOffset,
    bool useDynamicTheme,
    String? gender,
    int? ageStartedPraying,
    String? locationName,
  });
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? notificationsEnabled = null,
    Object? reminderHour = null,
    Object? reminderMinute = null,
    Object? seedColor = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? biometricLockEnabled = null,
    Object? silentHoursStart = null,
    Object? silentHoursEnd = null,
    Object? reminderOffset = null,
    Object? useDynamicTheme = null,
    Object? gender = freezed,
    Object? ageStartedPraying = freezed,
    Object? locationName = freezed,
  }) {
    return _then(
      _value.copyWith(
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            notificationsEnabled: null == notificationsEnabled
                ? _value.notificationsEnabled
                : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            reminderHour: null == reminderHour
                ? _value.reminderHour
                : reminderHour // ignore: cast_nullable_to_non_nullable
                      as int,
            reminderMinute: null == reminderMinute
                ? _value.reminderMinute
                : reminderMinute // ignore: cast_nullable_to_non_nullable
                      as int,
            seedColor: null == seedColor
                ? _value.seedColor
                : seedColor // ignore: cast_nullable_to_non_nullable
                      as int,
            soundEnabled: null == soundEnabled
                ? _value.soundEnabled
                : soundEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            vibrationEnabled: null == vibrationEnabled
                ? _value.vibrationEnabled
                : vibrationEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            biometricLockEnabled: null == biometricLockEnabled
                ? _value.biometricLockEnabled
                : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            silentHoursStart: null == silentHoursStart
                ? _value.silentHoursStart
                : silentHoursStart // ignore: cast_nullable_to_non_nullable
                      as int,
            silentHoursEnd: null == silentHoursEnd
                ? _value.silentHoursEnd
                : silentHoursEnd // ignore: cast_nullable_to_non_nullable
                      as int,
            reminderOffset: null == reminderOffset
                ? _value.reminderOffset
                : reminderOffset // ignore: cast_nullable_to_non_nullable
                      as int,
            useDynamicTheme: null == useDynamicTheme
                ? _value.useDynamicTheme
                : useDynamicTheme // ignore: cast_nullable_to_non_nullable
                      as bool,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            ageStartedPraying: freezed == ageStartedPraying
                ? _value.ageStartedPraying
                : ageStartedPraying // ignore: cast_nullable_to_non_nullable
                      as int?,
            locationName: freezed == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
    _$SettingsStateImpl value,
    $Res Function(_$SettingsStateImpl) then,
  ) = __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ThemeMode themeMode,
    bool notificationsEnabled,
    int reminderHour,
    int reminderMinute,
    int seedColor,
    bool soundEnabled,
    bool vibrationEnabled,
    bool biometricLockEnabled,
    int silentHoursStart,
    int silentHoursEnd,
    int reminderOffset,
    bool useDynamicTheme,
    String? gender,
    int? ageStartedPraying,
    String? locationName,
  });
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
    _$SettingsStateImpl _value,
    $Res Function(_$SettingsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? notificationsEnabled = null,
    Object? reminderHour = null,
    Object? reminderMinute = null,
    Object? seedColor = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? biometricLockEnabled = null,
    Object? silentHoursStart = null,
    Object? silentHoursEnd = null,
    Object? reminderOffset = null,
    Object? useDynamicTheme = null,
    Object? gender = freezed,
    Object? ageStartedPraying = freezed,
    Object? locationName = freezed,
  }) {
    return _then(
      _$SettingsStateImpl(
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        notificationsEnabled: null == notificationsEnabled
            ? _value.notificationsEnabled
            : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        reminderHour: null == reminderHour
            ? _value.reminderHour
            : reminderHour // ignore: cast_nullable_to_non_nullable
                  as int,
        reminderMinute: null == reminderMinute
            ? _value.reminderMinute
            : reminderMinute // ignore: cast_nullable_to_non_nullable
                  as int,
        seedColor: null == seedColor
            ? _value.seedColor
            : seedColor // ignore: cast_nullable_to_non_nullable
                  as int,
        soundEnabled: null == soundEnabled
            ? _value.soundEnabled
            : soundEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        vibrationEnabled: null == vibrationEnabled
            ? _value.vibrationEnabled
            : vibrationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        biometricLockEnabled: null == biometricLockEnabled
            ? _value.biometricLockEnabled
            : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        silentHoursStart: null == silentHoursStart
            ? _value.silentHoursStart
            : silentHoursStart // ignore: cast_nullable_to_non_nullable
                  as int,
        silentHoursEnd: null == silentHoursEnd
            ? _value.silentHoursEnd
            : silentHoursEnd // ignore: cast_nullable_to_non_nullable
                  as int,
        reminderOffset: null == reminderOffset
            ? _value.reminderOffset
            : reminderOffset // ignore: cast_nullable_to_non_nullable
                  as int,
        useDynamicTheme: null == useDynamicTheme
            ? _value.useDynamicTheme
            : useDynamicTheme // ignore: cast_nullable_to_non_nullable
                  as bool,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        ageStartedPraying: freezed == ageStartedPraying
            ? _value.ageStartedPraying
            : ageStartedPraying // ignore: cast_nullable_to_non_nullable
                  as int?,
        locationName: freezed == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SettingsStateImpl implements _SettingsState {
  const _$SettingsStateImpl({
    this.themeMode = ThemeMode.dark,
    this.notificationsEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.seedColor = 0xFF10B981,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.biometricLockEnabled = false,
    this.silentHoursStart = 22,
    this.silentHoursEnd = 6,
    this.reminderOffset = 15,
    this.useDynamicTheme = false,
    this.gender,
    this.ageStartedPraying,
    this.locationName,
  });

  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  @JsonKey()
  final int reminderHour;
  @override
  @JsonKey()
  final int reminderMinute;
  @override
  @JsonKey()
  final int seedColor;
  // Default Islamic Green
  @override
  @JsonKey()
  final bool soundEnabled;
  @override
  @JsonKey()
  final bool vibrationEnabled;
  @override
  @JsonKey()
  final bool biometricLockEnabled;
  @override
  @JsonKey()
  final int silentHoursStart;
  // 10 PM
  @override
  @JsonKey()
  final int silentHoursEnd;
  // 6 AM
  @override
  @JsonKey()
  final int reminderOffset;
  // 15 mins before
  @override
  @JsonKey()
  final bool useDynamicTheme;
  @override
  final String? gender;
  @override
  final int? ageStartedPraying;
  @override
  final String? locationName;

  @override
  String toString() {
    return 'SettingsState(themeMode: $themeMode, notificationsEnabled: $notificationsEnabled, reminderHour: $reminderHour, reminderMinute: $reminderMinute, seedColor: $seedColor, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, biometricLockEnabled: $biometricLockEnabled, silentHoursStart: $silentHoursStart, silentHoursEnd: $silentHoursEnd, reminderOffset: $reminderOffset, useDynamicTheme: $useDynamicTheme, gender: $gender, ageStartedPraying: $ageStartedPraying, locationName: $locationName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.reminderHour, reminderHour) ||
                other.reminderHour == reminderHour) &&
            (identical(other.reminderMinute, reminderMinute) ||
                other.reminderMinute == reminderMinute) &&
            (identical(other.seedColor, seedColor) ||
                other.seedColor == seedColor) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled) &&
            (identical(other.biometricLockEnabled, biometricLockEnabled) ||
                other.biometricLockEnabled == biometricLockEnabled) &&
            (identical(other.silentHoursStart, silentHoursStart) ||
                other.silentHoursStart == silentHoursStart) &&
            (identical(other.silentHoursEnd, silentHoursEnd) ||
                other.silentHoursEnd == silentHoursEnd) &&
            (identical(other.reminderOffset, reminderOffset) ||
                other.reminderOffset == reminderOffset) &&
            (identical(other.useDynamicTheme, useDynamicTheme) ||
                other.useDynamicTheme == useDynamicTheme) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.ageStartedPraying, ageStartedPraying) ||
                other.ageStartedPraying == ageStartedPraying) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    themeMode,
    notificationsEnabled,
    reminderHour,
    reminderMinute,
    seedColor,
    soundEnabled,
    vibrationEnabled,
    biometricLockEnabled,
    silentHoursStart,
    silentHoursEnd,
    reminderOffset,
    useDynamicTheme,
    gender,
    ageStartedPraying,
    locationName,
  );

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState({
    final ThemeMode themeMode,
    final bool notificationsEnabled,
    final int reminderHour,
    final int reminderMinute,
    final int seedColor,
    final bool soundEnabled,
    final bool vibrationEnabled,
    final bool biometricLockEnabled,
    final int silentHoursStart,
    final int silentHoursEnd,
    final int reminderOffset,
    final bool useDynamicTheme,
    final String? gender,
    final int? ageStartedPraying,
    final String? locationName,
  }) = _$SettingsStateImpl;

  @override
  ThemeMode get themeMode;
  @override
  bool get notificationsEnabled;
  @override
  int get reminderHour;
  @override
  int get reminderMinute;
  @override
  int get seedColor; // Default Islamic Green
  @override
  bool get soundEnabled;
  @override
  bool get vibrationEnabled;
  @override
  bool get biometricLockEnabled;
  @override
  int get silentHoursStart; // 10 PM
  @override
  int get silentHoursEnd; // 6 AM
  @override
  int get reminderOffset; // 15 mins before
  @override
  bool get useDynamicTheme;
  @override
  String? get gender;
  @override
  int? get ageStartedPraying;
  @override
  String? get locationName;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
