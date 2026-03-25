import 'package:flutter/services.dart';

class InteractionService {
  static Future<void> tap() async {
    HapticFeedback.selectionClick();
  }

  static Future<void> success() async {
    HapticFeedback.mediumImpact();
  }

  static Future<void> levelUp() async {
    HapticFeedback.heavyImpact();
  }

  static Future<void> error() async {
    HapticFeedback.heavyImpact();
    // No sound for error usually, or a subtle one
  }
}
