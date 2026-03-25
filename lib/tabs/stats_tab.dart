import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/kaza_cubit.dart';
import '../cubit/kaza_state.dart';
import '../models/kaza_model.dart';
import '../widgets/progress_pie_chart.dart';
import '../widgets/weekly_trend_chart.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/activity_heatmap.dart';
import '../services/analytics_service.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KazaCubit, KazaState>(
      builder: (context, state) {
        if (state.status == KazaStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = state.data;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  "stats.totalProgress".tr(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Leveling Card
                _buildLevelCard(context, data),
                const SizedBox(height: 24),

                // Daily Goal Card
                DailyGoalCard(data: data),
                const SizedBox(height: 24),

                // Streak Card
                _buildStreakCard(context, data),
                const SizedBox(height: 24),

                // Progress Chart Card
                _buildProgressChartCard(context, data),
                const SizedBox(height: 24),

                // Weekly Trend Card
                _buildWeeklyTrendCard(context, state.history),
                const SizedBox(height: 24),

                // Activity Heatmap
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ActivityHeatmap(
                      data: state.history,
                      baseColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Achievements Header
                Text(
                  "achievements.title".tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Achievements Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildAchievementBadge(
                      context,
                      'prayers100',
                      Icons.star_rounded,
                      "achievements.prayers100".tr(),
                      data.achievements.contains('prayers100'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'prayers500',
                      Icons.workspace_premium_rounded,
                      "achievements.prayers500".tr(),
                      data.achievements.contains('prayers500'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'prayers1000',
                      Icons.military_tech_rounded,
                      "achievements.prayers1000".tr(),
                      data.achievements.contains('prayers1000'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'level10',
                      Icons.trending_up_rounded,
                      "achievements.level10".tr(),
                      data.achievements.contains('level10'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'level25',
                      Icons.auto_awesome_rounded,
                      "achievements.level25".tr(),
                      data.achievements.contains('level25'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'streak7',
                      Icons.flash_on_rounded,
                      "achievements.streak7".tr(),
                      data.achievements.contains('streak7'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'streak30',
                      Icons.local_fire_department_rounded,
                      "achievements.streak30".tr(),
                      data.achievements.contains('streak30'),
                    ),
                    _buildAchievementBadge(
                      context,
                      'dailyGoalMet',
                      Icons.task_alt_rounded,
                      "achievements.dailyGoalMet".tr(),
                      data.achievements.contains('dailyGoalMet'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakCard(BuildContext context, KazaModel data) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.orange,
                    size: 32,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2.seconds),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "streaks.title".tr(),
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${data.currentStreak}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "streaks.days".tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${"streaks.best".tr()}: ${data.bestStreak}",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, KazaModel data) {
    final colorScheme = Theme.of(context).colorScheme;
    final double xpProgress = data.exp / data.xpForNextLevel;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level ${data.level} - ${data.rankName}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "XP: ${data.exp} / ${data.xpForNextLevel}",
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Icon(data.rankIcon, color: colorScheme.primary, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: xpProgress,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChartCard(BuildContext context, KazaModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Progress Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ProgressPieChart(data: data),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTrendCard(
    BuildContext context,
    Map<DateTime, int> history,
  ) {
    final comparison = AnalyticsService.compareWeekly(history);
    final activity = AnalyticsService.getLast7DaysActivity(history);

    final isIncrease = comparison['isIncrease'] as bool;
    final double change = (comparison['percentageChange'] as num).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Weekly Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isIncrease ? Colors.green : Colors.red).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isIncrease ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: isIncrease ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${change.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isIncrease ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            WeeklyTrendChart(activity: activity),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    String id,
    IconData icon,
    String label,
    bool unlocked,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: unlocked
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.onSurface.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: unlocked
                    ? colorScheme.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              icon,
              color: unlocked
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.2),
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            color: unlocked
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
