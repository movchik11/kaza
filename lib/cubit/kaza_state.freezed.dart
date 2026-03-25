// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kaza_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KazaState {
  KazaModel get data => throw _privateConstructorUsedError;
  Map<DateTime, int> get history => throw _privateConstructorUsedError;
  List<DateTime> get voluntaryFasts => throw _privateConstructorUsedError;
  KazaStatus get status => throw _privateConstructorUsedError;
  double get dailyAverageRate => throw _privateConstructorUsedError;
  DateTime? get expectedCompletionDate => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of KazaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KazaStateCopyWith<KazaState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KazaStateCopyWith<$Res> {
  factory $KazaStateCopyWith(KazaState value, $Res Function(KazaState) then) =
      _$KazaStateCopyWithImpl<$Res, KazaState>;
  @useResult
  $Res call({
    KazaModel data,
    Map<DateTime, int> history,
    List<DateTime> voluntaryFasts,
    KazaStatus status,
    double dailyAverageRate,
    DateTime? expectedCompletionDate,
    String? errorMessage,
  });

  $KazaModelCopyWith<$Res> get data;
}

/// @nodoc
class _$KazaStateCopyWithImpl<$Res, $Val extends KazaState>
    implements $KazaStateCopyWith<$Res> {
  _$KazaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KazaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? history = null,
    Object? voluntaryFasts = null,
    Object? status = null,
    Object? dailyAverageRate = null,
    Object? expectedCompletionDate = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as KazaModel,
            history: null == history
                ? _value.history
                : history // ignore: cast_nullable_to_non_nullable
                      as Map<DateTime, int>,
            voluntaryFasts: null == voluntaryFasts
                ? _value.voluntaryFasts
                : voluntaryFasts // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as KazaStatus,
            dailyAverageRate: null == dailyAverageRate
                ? _value.dailyAverageRate
                : dailyAverageRate // ignore: cast_nullable_to_non_nullable
                      as double,
            expectedCompletionDate: freezed == expectedCompletionDate
                ? _value.expectedCompletionDate
                : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of KazaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KazaModelCopyWith<$Res> get data {
    return $KazaModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KazaStateImplCopyWith<$Res>
    implements $KazaStateCopyWith<$Res> {
  factory _$$KazaStateImplCopyWith(
    _$KazaStateImpl value,
    $Res Function(_$KazaStateImpl) then,
  ) = __$$KazaStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    KazaModel data,
    Map<DateTime, int> history,
    List<DateTime> voluntaryFasts,
    KazaStatus status,
    double dailyAverageRate,
    DateTime? expectedCompletionDate,
    String? errorMessage,
  });

  @override
  $KazaModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$KazaStateImplCopyWithImpl<$Res>
    extends _$KazaStateCopyWithImpl<$Res, _$KazaStateImpl>
    implements _$$KazaStateImplCopyWith<$Res> {
  __$$KazaStateImplCopyWithImpl(
    _$KazaStateImpl _value,
    $Res Function(_$KazaStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KazaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? history = null,
    Object? voluntaryFasts = null,
    Object? status = null,
    Object? dailyAverageRate = null,
    Object? expectedCompletionDate = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$KazaStateImpl(
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as KazaModel,
        history: null == history
            ? _value._history
            : history // ignore: cast_nullable_to_non_nullable
                  as Map<DateTime, int>,
        voluntaryFasts: null == voluntaryFasts
            ? _value._voluntaryFasts
            : voluntaryFasts // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as KazaStatus,
        dailyAverageRate: null == dailyAverageRate
            ? _value.dailyAverageRate
            : dailyAverageRate // ignore: cast_nullable_to_non_nullable
                  as double,
        expectedCompletionDate: freezed == expectedCompletionDate
            ? _value.expectedCompletionDate
            : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$KazaStateImpl implements _KazaState {
  const _$KazaStateImpl({
    this.data = const KazaModel(),
    final Map<DateTime, int> history = const {},
    final List<DateTime> voluntaryFasts = const [],
    this.status = KazaStatus.initial,
    this.dailyAverageRate = 0,
    this.expectedCompletionDate,
    this.errorMessage,
  }) : _history = history,
       _voluntaryFasts = voluntaryFasts;

  @override
  @JsonKey()
  final KazaModel data;
  final Map<DateTime, int> _history;
  @override
  @JsonKey()
  Map<DateTime, int> get history {
    if (_history is EqualUnmodifiableMapView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_history);
  }

  final List<DateTime> _voluntaryFasts;
  @override
  @JsonKey()
  List<DateTime> get voluntaryFasts {
    if (_voluntaryFasts is EqualUnmodifiableListView) return _voluntaryFasts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voluntaryFasts);
  }

  @override
  @JsonKey()
  final KazaStatus status;
  @override
  @JsonKey()
  final double dailyAverageRate;
  @override
  final DateTime? expectedCompletionDate;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'KazaState(data: $data, history: $history, voluntaryFasts: $voluntaryFasts, status: $status, dailyAverageRate: $dailyAverageRate, expectedCompletionDate: $expectedCompletionDate, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KazaStateImpl &&
            (identical(other.data, data) || other.data == data) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            const DeepCollectionEquality().equals(
              other._voluntaryFasts,
              _voluntaryFasts,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dailyAverageRate, dailyAverageRate) ||
                other.dailyAverageRate == dailyAverageRate) &&
            (identical(other.expectedCompletionDate, expectedCompletionDate) ||
                other.expectedCompletionDate == expectedCompletionDate) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    data,
    const DeepCollectionEquality().hash(_history),
    const DeepCollectionEquality().hash(_voluntaryFasts),
    status,
    dailyAverageRate,
    expectedCompletionDate,
    errorMessage,
  );

  /// Create a copy of KazaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KazaStateImplCopyWith<_$KazaStateImpl> get copyWith =>
      __$$KazaStateImplCopyWithImpl<_$KazaStateImpl>(this, _$identity);
}

abstract class _KazaState implements KazaState {
  const factory _KazaState({
    final KazaModel data,
    final Map<DateTime, int> history,
    final List<DateTime> voluntaryFasts,
    final KazaStatus status,
    final double dailyAverageRate,
    final DateTime? expectedCompletionDate,
    final String? errorMessage,
  }) = _$KazaStateImpl;

  @override
  KazaModel get data;
  @override
  Map<DateTime, int> get history;
  @override
  List<DateTime> get voluntaryFasts;
  @override
  KazaStatus get status;
  @override
  double get dailyAverageRate;
  @override
  DateTime? get expectedCompletionDate;
  @override
  String? get errorMessage;

  /// Create a copy of KazaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KazaStateImplCopyWith<_$KazaStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
