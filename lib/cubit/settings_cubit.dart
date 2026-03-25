import 'package:flutter/material.dart' show ThemeMode, TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/kaza_repository.dart';
import '../services/notification_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final KazaRepository _repository;
  final NotificationService _notificationService;

  SettingsCubit(this._repository, this._notificationService)
    : super(const SettingsState());

  /// Load settings from repository
  Future<void> loadSettings() async {
    final settings = await _repository.getNotificationSettings();
    emit(
      state.copyWith(
        notificationsEnabled: settings['enabled'] as bool? ?? false,
        reminderHour: settings['hour'] as int? ?? 20,
        reminderMinute: settings['minute'] as int? ?? 0,
        seedColor: settings['theme_color'] as int? ?? 0xFF10B981,
        soundEnabled: settings['sound_enabled'] as bool? ?? true,
        vibrationEnabled: settings['vibration_enabled'] as bool? ?? true,
        biometricLockEnabled: settings['biometric_lock'] as bool? ?? false,
        silentHoursStart: settings['silent_start'] as int? ?? 22,
        silentHoursEnd: settings['silent_end'] as int? ?? 6,
        reminderOffset: settings['reminder_offset'] as int? ?? 15,
        useDynamicTheme: settings['use_dynamic_theme'] as bool? ?? false,
        gender: settings['gender'] as String?,
        ageStartedPraying: settings['age_started_praying'] as int?,
        locationName: settings['location_name'] as String?,
      ),
    );
  }

  /// Toggle theme mode
  void toggleTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  /// Change theme seed color
  void setThemeColor(int color) {
    emit(state.copyWith(seedColor: color));
    _repository.saveThemeColor(color);
  }

  /// Toggle notifications on/off
  Future<void> toggleNotifications(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));
    await _repository.saveNotificationSettings(
      enabled,
      state.reminderHour,
      state.reminderMinute,
    );

    if (enabled) {
      await _notificationService.scheduleDailyReminder(
        time: TimeOfDay(hour: state.reminderHour, minute: state.reminderMinute),
        offsetMinutes: state.reminderOffset,
        silentStart: state.silentHoursStart,
        silentEnd: state.silentHoursEnd,
      );
    } else {
      await _notificationService.cancelNotifications();
    }
  }

  /// Set reminder time
  Future<void> setReminderTime(int hour, int minute) async {
    emit(state.copyWith(reminderHour: hour, reminderMinute: minute));
    await _repository.saveNotificationSettings(
      state.notificationsEnabled,
      hour,
      minute,
    );

    if (state.notificationsEnabled) {
      await _notificationService.scheduleDailyReminder(
        time: TimeOfDay(hour: hour, minute: minute),
        offsetMinutes: state.reminderOffset,
        silentStart: state.silentHoursStart,
        silentEnd: state.silentHoursEnd,
      );
    }
  }

  void toggleSound(bool enabled) {
    emit(state.copyWith(soundEnabled: enabled));
    _repository.saveInteractionSettings(enabled, state.vibrationEnabled);
  }

  void toggleVibration(bool enabled) {
    emit(state.copyWith(vibrationEnabled: enabled));
    _repository.saveInteractionSettings(state.soundEnabled, enabled);
  }

  void toggleBiometricLock(bool enabled) {
    emit(state.copyWith(biometricLockEnabled: enabled));
    _repository.saveBiometricLock(enabled);
  }

  void setReminderOffset(int minutes) {
    emit(state.copyWith(reminderOffset: minutes));
    _repository.saveReminderOffset(minutes);
  }

  void setSilentHours(int start, int end) {
    emit(state.copyWith(silentHoursStart: start, silentHoursEnd: end));
    _repository.saveSilentHours(start, end);
  }

  void toggleDynamicTheme(bool enabled) {
    emit(state.copyWith(useDynamicTheme: enabled));
    _repository.saveDynamicThemeEnabled(enabled);
  }

  Future<void> saveProfile({
    String? gender,
    int? ageStartedPraying,
    String? locationName,
  }) async {
    await _repository.saveProfile(gender, ageStartedPraying, locationName);

    // Create a new state but only overwrite the provided non-null values
    // (or just overwrite them unconditionally if we pass the current ones when not changing).
    // Let's assume we pass all we want to update. Wait, if we use copyWith, we need to pass the existing ones if they are null and shouldn't change.
    // So let's handle updates carefully.

    emit(
      state.copyWith(
        gender: gender ?? state.gender,
        ageStartedPraying: ageStartedPraying ?? state.ageStartedPraying,
        locationName: locationName ?? state.locationName,
      ),
    );
  }
}
