import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../repositories/kaza_repository.dart';
import '../utils/intl_utils.dart';

class HeatmapWidget extends StatelessWidget {
  final KazaRepository repository;

  const HeatmapWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final history = repository.getHistory();
    // Generate last 70 days
    final now = DateTime.now();
    final days = List.generate(70, (index) {
      return now.subtract(Duration(days: 69 - index));
    });

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "stats.activityHistory".tr(),
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: days.map((date) {
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final count = history[normalizedDate] ?? 0;

              Color color;
              if (count == 0) {
                color = Colors.white.withValues(alpha: 0.05);
              } else if (count < 6) {
                color = colorScheme.primary.withValues(alpha: 0.3);
              } else if (count < 15) {
                color = colorScheme.primary.withValues(alpha: 0.6);
              } else {
                color = colorScheme.primary;
              }

              return Tooltip(
                message:
                    "${DateFormat('MMM d', IntlUtils.getSafeLocale(context)).format(date)}: $count",
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }).toList(),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

// Note: I need to fix the import of KazaRepository in this file.
