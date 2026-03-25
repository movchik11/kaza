import 'package:flutter/material.dart';

class ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> data;
  final Color baseColor;

  const ActivityHeatmap({
    super.key,
    required this.data,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Show last 12 weeks for better layout on mobile
    final totalWeeks = 15;
    final totalDays = totalWeeks * 7;
    final startDate = now.subtract(Duration(days: totalDays - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activity History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Last 15 Weeks',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(totalWeeks, (weekIndex) {
              return Column(
                children: List.generate(7, (dayIndex) {
                  final date = startDate.add(
                    Duration(days: (weekIndex * 7) + dayIndex),
                  );
                  final count = _getCountForDate(date);
                  final intensity = _getIntensity(count);

                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: date.isAfter(now)
                          ? Colors.transparent
                          : baseColor.withValues(alpha: intensity),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: date.isAfter(now)
                            ? Colors.transparent
                            : baseColor.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  int _getCountForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return data[normalizedDate] ?? 0;
  }

  double _getIntensity(int count) {
    if (count == 0) return 0.05;
    if (count <= 2) return 0.2;
    if (count <= 4) return 0.4;
    if (count <= 6) return 0.7;
    return 1.0;
  }
}
