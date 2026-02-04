import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';

class HeatmapWidget extends StatelessWidget {
  final Map<DateTime, int> history;

  const HeatmapWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    // Generate last 70 days
    final now = DateTime.now();
    final days = List.generate(70, (index) {
      return now.subtract(Duration(days: 69 - index));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            "activityHistory".tr(),
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: days.map((date) {
            // Find activity for this date
            // Normalize date keys to match repository logic
            final normalizedDate = DateTime(date.year, date.month, date.day);
            final count = history[normalizedDate] ?? 0;

            Color color;
            if (count == 0) {
              color = Colors.white.withAlpha(13);
            } else if (count < 6) {
              color = const Color(0xFF065F46); // Dark Emerald
            } else if (count < 15) {
              color = const Color(0xFF10B981); // Emerald
            } else {
              color = const Color(0xFF34D399); // Bright Emerald
            }

            return Tooltip(
              message: "${date.day}/${date.month}: $count prayers",
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(),
      ],
    );
  }
}
