import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

class ThemePreset {
  final String name;
  final Color primary;
  final Color secondary;
  final Brightness brightness;

  const ThemePreset({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.brightness,
  });
}

class ThemeService {
  static final List<ThemePreset> presets = [
    const ThemePreset(
      name: 'Default',
      primary: Color(0xFF10B981), // Islamic Green
      secondary: Color(0xFF059669),
      brightness: Brightness.dark,
    ),
    const ThemePreset(
      name: 'Mecca Night',
      primary: Color(0xFF6366F1), // Indigo
      secondary: Color(0xFF4F46E5),
      brightness: Brightness.dark,
    ),
    const ThemePreset(
      name: 'Emerald Garden',
      primary: Color(0xFF059669),
      secondary: Color(0xFF047857),
      brightness: Brightness.light,
    ),
    const ThemePreset(
      name: 'Minimalist',
      primary: Color(0xFF3B82F6), // Blue
      secondary: Color(0xFF2563EB),
      brightness: Brightness.light,
    ),
  ];

  static ThemePreset getDynamicPreset(DateTime now, {PrayerTimes? prayers}) {
    if (prayers == null) return presets[0];

    final hour = now.hour;

    // Determine theme based on nearest prayer or time of day
    if (hour >= 20 || hour < 4) {
      // Night / Isha
      return const ThemePreset(
        name: 'Night',
        primary: Color(0xFF6366F1), // Indigo
        secondary: Color(0xFF4F46E5),
        brightness: Brightness.dark,
      );
    } else if (hour >= 4 && hour < 7) {
      // Dawn / Fajr
      return const ThemePreset(
        name: 'Dawn',
        primary: Color(0xFFF59E0B), // Amber/Gold
        secondary: Color(0xFFD97706),
        brightness: Brightness.dark,
      );
    } else if (hour >= 7 && hour < 17) {
      // Day / Dhuhr-Asr
      return const ThemePreset(
        name: 'Day',
        primary: Color(0xFF10B981), // Islamic Green
        secondary: Color(0xFF059669),
        brightness: Brightness.light,
      );
    } else {
      // Evening / Maghrib
      return const ThemePreset(
        name: 'Evening',
        primary: Color(0xFFEC4899), // Pink/Rose
        secondary: Color(0xFFDB2777),
        brightness: Brightness.dark,
      );
    }
  }

  static ThemeData getThemeData(ThemePreset preset) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: preset.primary,
        primary: preset.primary,
        secondary: preset.secondary,
        brightness: preset.brightness,
        surface: preset.brightness == Brightness.dark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
      ),
      scaffoldBackgroundColor: preset.brightness == Brightness.dark
          ? const Color(0xFF020617)
          : const Color(0xFFF1F5F9),
      cardTheme: CardThemeData(
        elevation: 0,
        color: preset.brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: preset.brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
    );
  }
}
