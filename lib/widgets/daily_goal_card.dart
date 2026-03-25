import 'package:flutter/material.dart';
import '../models/kaza_model.dart';

class DailyGoalCard extends StatelessWidget {
  final KazaModel data;

  const DailyGoalCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double progress = (data.completedToday / data.dailyGoal).clamp(
      0.0,
      1.0,
    );
    final bool isCompleted = data.completedToday >= data.dailyGoal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Daily Goal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle_rounded, color: Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: isCompleted ? Colors.green : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${data.completedToday} / ${data.dailyGoal} prayers completed today",
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
