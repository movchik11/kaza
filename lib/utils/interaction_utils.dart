import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/settings_cubit.dart';

class InteractionUtils {
  /// Simple haptic feedback that respects user settings
  static void haptic(BuildContext context) {
    final settings = context.read<SettingsCubit>().state;
    if (settings.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium haptic feedback for significant actions
  static void mediumImpact(BuildContext context) {
    final settings = context.read<SettingsCubit>().state;
    if (settings.vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Selection haptic feedback
  static void selectionClick(BuildContext context) {
    final settings = context.read<SettingsCubit>().state;
    if (settings.vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
  }
}
