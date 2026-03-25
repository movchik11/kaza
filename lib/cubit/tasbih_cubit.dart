import 'package:flutter_bloc/flutter_bloc.dart';
import 'tasbih_state.dart';
import '../repositories/kaza_repository.dart';

class TasbihCubit extends Cubit<TasbihState> {
  final KazaRepository repository;

  TasbihCubit({required this.repository}) : super(const TasbihState()) {
    _loadData();
  }

  void _loadData() {
    final data = repository.getTasbihData();
    emit(
      TasbihState(
        count: data['count'] ?? 0,
        laps: data['laps'] ?? 0,
        target: data['target'] ?? 33,
      ),
    );
  }

  void increment() {
    if (state.count >= state.target) {
      // Reached the target previously, so now reset to 1 and increment lap
      final newState = state.copyWith(count: 1, laps: state.laps + 1);
      _emitAndSave(newState);
    } else {
      // Normal increment
      final newCount = state.count + 1;
      final newState = state.copyWith(count: newCount);
      _emitAndSave(newState);
    }
  }

  void resetCount() {
    final newState = state.copyWith(count: 0);
    _emitAndSave(newState);
  }

  void resetAll() {
    final newState = state.copyWith(count: 0, laps: 0);
    _emitAndSave(newState);
  }

  void setTarget(int target) {
    final newState = state.copyWith(target: target, count: 0);
    _emitAndSave(newState);
  }

  void _emitAndSave(TasbihState newState) {
    emit(newState);
    repository.saveTasbihData(
      count: newState.count,
      laps: newState.laps,
      target: newState.target,
    );
  }
}
