import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import 'kaza_state.dart';

class KazaCubit extends Cubit<KazaState> {
  final KazaRepository _repository;

  KazaCubit(this._repository) : super(const KazaState());

  /// Load initial data from repository
  Future<void> loadData() async {
    emit(state.copyWith(status: KazaStatus.loading));
    try {
      final data = _repository.getKazaData();
      final history = _repository.getHistory();
      final voluntaryFasts = _repository.getVoluntaryFasts();
      final rate = _repository.getDailyAverageRate();
      final completionDate = _repository.getExpectedCompletionDate();
      emit(
        state.copyWith(
          data: data,
          history: history,
          voluntaryFasts: voluntaryFasts,
          status: KazaStatus.loaded,
          dailyAverageRate: rate,
          expectedCompletionDate: completionDate,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: KazaStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// Decrement a prayer by the given amount
  Future<void> decrementPrayer(PrayerType type, [int amount = 1]) async {
    await _repository.decrementPrayer(type, amount);
    final data = _repository.getKazaData();
    final history = _repository.getHistory();
    final rate = _repository.getDailyAverageRate();
    final completionDate = _repository.getExpectedCompletionDate();
    emit(
      state.copyWith(
        data: data,
        history: history,
        dailyAverageRate: rate,
        expectedCompletionDate: completionDate,
      ),
    );
  }

  /// Bulk decrement: close a full day (all 6 prayers)
  Future<void> decrementDay() async {
    await _repository.decrementDay();
    final data = _repository.getKazaData();
    final history = _repository.getHistory();
    emit(state.copyWith(data: data, history: history));
  }

  /// Increment a Sunnah prayer
  Future<void> incrementSunnah(PrayerType type, [int amount = 1]) async {
    await _repository.incrementSunnah(type, amount);
    final data = _repository.getKazaData();
    emit(state.copyWith(data: data));
  }

  /// Increment a Nafl prayer
  Future<void> incrementNafl([int amount = 1]) async {
    await _repository.incrementNafl(amount);
    final data = _repository.getKazaData();
    emit(state.copyWith(data: data));
  }

  /// Update Quran reading progress
  Future<void> updateQuranProgress(int surah, int page) async {
    await _repository.updateQuranProgress(surah, page);
    final data = _repository.getKazaData();
    emit(state.copyWith(data: data));
  }

  /// Toggle Voluntary Fasting day
  Future<void> toggleVoluntaryFast(DateTime date) async {
    await _repository.toggleVoluntaryFast(date);
    final data = _repository.getKazaData();
    final voluntaryFasts = _repository.getVoluntaryFasts();
    emit(state.copyWith(data: data, voluntaryFasts: voluntaryFasts));
  }

  /// Unlock theme
  Future<bool> unlockTheme(int themeColor, int cost) async {
    final success = await _repository.unlockTheme(themeColor, cost);
    if (success) {
      final data = _repository.getKazaData();
      emit(state.copyWith(data: data));
    }
    return success;
  }

  /// Bulk add: add multiple counts at once (e.g., +10 or +30)
  Future<void> bulkAdd(PrayerType type, int amount) async {
    final current = state.data;
    int newValue = current.getCount(type) + amount;

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

    await _repository.saveKazaData(updated);
    final history = _repository.getHistory();
    final rate = _repository.getDailyAverageRate();
    final completionDate = _repository.getExpectedCompletionDate();
    emit(
      state.copyWith(
        data: updated,
        history: history,
        dailyAverageRate: rate,
        expectedCompletionDate: completionDate,
      ),
    );
  }

  /// Set initial data (from onboarding)
  Future<void> setInitialData(KazaModel data) async {
    await _repository.setInitialData(data);
    final rate = _repository.getDailyAverageRate();
    final completionDate = _repository.getExpectedCompletionDate();
    emit(
      state.copyWith(
        data: data,
        status: KazaStatus.loaded,
        dailyAverageRate: rate,
        expectedCompletionDate: completionDate,
      ),
    );
  }

  bool get isFirstRun => _repository.isFirstRun;
}
