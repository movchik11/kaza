import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/kaza_model.dart';

part 'kaza_state.freezed.dart';

enum KazaStatus { initial, loading, loaded, error }

@freezed
class KazaState with _$KazaState {
  const factory KazaState({
    @Default(KazaModel()) KazaModel data,
    @Default({}) Map<DateTime, int> history,
    @Default([]) List<DateTime> voluntaryFasts,
    @Default(KazaStatus.initial) KazaStatus status,
    @Default(0) double dailyAverageRate,
    DateTime? expectedCompletionDate,
    String? errorMessage,
  }) = _KazaState;
}
