import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(ThemeMode.dark) ThemeMode themeMode,
    @Default(false) bool notificationsEnabled,
    @Default(20) int reminderHour,
    @Default(0) int reminderMinute,
    @Default(0xFF10B981) int seedColor, // Default Islamic Green
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    @Default(false) bool biometricLockEnabled,
    @Default(22) int silentHoursStart, // 10 PM
    @Default(6) int silentHoursEnd, // 6 AM
    @Default(15) int reminderOffset, // 15 mins before
    @Default(false) bool useDynamicTheme,
    String? gender,
    int? ageStartedPraying,
    String? locationName,
  }) = _SettingsState;
}
