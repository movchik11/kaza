import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/kaza_cubit.dart';
import '../cubit/kaza_state.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import '../widgets/heatmap_widget.dart';

import '../services/content_service.dart';

import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/intl_utils.dart';
import '../utils/interaction_utils.dart';

class PrayersTab extends StatefulWidget {
  final KazaRepository repository;
  const PrayersTab({super.key, required this.repository});

  @override
  State<PrayersTab> createState() => _PrayersTabState();
}

class _PrayersTabState extends State<PrayersTab> {
  late ConfettiController _confettiController;
  bool _isTrackingKaza = true;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<KazaCubit, KazaState>(
      listener: (context, state) {
        // Optional: logic to trigger stuff on state changes
      },
      builder: (context, state) {
        final data = state.data;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'prayers.title'.tr(),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'prayers.subtitle'.tr(),
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 40,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline),
                                  onPressed: () => _showHelpDialog(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDailyVerseCard(context, colorScheme),
                          const SizedBox(height: 24),
                          _buildModeToggle(context, colorScheme),
                          const SizedBox(height: 24),
                          if (_isTrackingKaza) ...[
                            _buildProgressHeader(context, colorScheme, data),
                            const SizedBox(height: 32),
                            _buildStatsDashboard(context, colorScheme, state),
                            const SizedBox(height: 32),
                          ] else ...[
                            Text(
                              'prayers.sunnahSubtitle'.tr(),
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          _buildPrayerGrid(context, data),
                          if (_isTrackingKaza) ...[
                            const SizedBox(height: 32),
                            _buildFullDayAction(context, colorScheme),
                            const SizedBox(height: 32),
                            HeatmapWidget(repository: widget.repository),
                            const SizedBox(height: 32),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                    Colors.amber,
                    Colors.white,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _fireConfetti() {
    _confettiController.play();
  }

  Widget _buildModeToggle(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption(
              context: context,
              title: 'prayers.modeKaza'.tr(),
              isSelected: _isTrackingKaza,
              onTap: () => setState(() => _isTrackingKaza = true),
            ),
          ),
          Expanded(
            child: _buildToggleOption(
              context: context,
              title: 'prayers.modeSunnah'.tr(),
              isSelected: !_isTrackingKaza,
              onTap: () => setState(() => _isTrackingKaza = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        InteractionUtils.haptic(context);
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerGrid(BuildContext context, KazaModel data) {
    if (_isTrackingKaza) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildPrayerCard(context, PrayerType.fajr, 'prayers.fajr'.tr(), data),
          _buildPrayerCard(
            context,
            PrayerType.dhuhr,
            'prayers.dhuhr'.tr(),
            data,
          ),
          _buildPrayerCard(context, PrayerType.asr, 'prayers.asr'.tr(), data),
          _buildPrayerCard(
            context,
            PrayerType.maghrib,
            'prayers.maghrib'.tr(),
            data,
          ),
          _buildPrayerCard(context, PrayerType.isha, 'prayers.isha'.tr(), data),
          _buildPrayerCard(context, PrayerType.witr, 'prayers.witr'.tr(), data),
        ],
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildSunnahCard(
            context,
            PrayerType.fajr,
            'prayers.fajr'.tr(),
            data.sunnahFajr,
          ),
          _buildSunnahCard(
            context,
            PrayerType.dhuhr,
            'prayers.dhuhr'.tr(),
            data.sunnahDhuhr,
          ),
          _buildSunnahCard(
            context,
            PrayerType.asr,
            'prayers.asr'.tr(),
            data.sunnahAsr,
          ),
          _buildSunnahCard(
            context,
            PrayerType.maghrib,
            'prayers.maghrib'.tr(),
            data.sunnahMaghrib,
          ),
          _buildSunnahCard(
            context,
            PrayerType.isha,
            'prayers.isha'.tr(),
            data.sunnahIsha,
          ),
          _buildSunnahCard(
            context,
            PrayerType.fasting,
            'prayers.nafl'.tr(),
            data.nafl,
            isNafl: true,
          ),
        ],
      );
    }
  }

  Widget _buildDailyVerseCard(BuildContext context, ColorScheme colorScheme) {
    final verse = ContentService.getDailyVerse();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.05),
            colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'library.dailyVerse'.tr(),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            verse['text']!,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "— ${verse['source']}",
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildProgressHeader(
    BuildContext context,
    ColorScheme colorScheme,
    KazaModel data,
  ) {
    final progress = data.progress;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'stats.totalProgress'.tr(),
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.totalRemaining.toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'prayers.subtitle'.tr(),
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildPrayerCard(
    BuildContext context,
    PrayerType type,
    String label,
    KazaModel data,
  ) {
    final count = data.getCount(type);
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<KazaCubit>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          InteractionUtils.haptic(context);
          cubit.decrementPrayer(type);
          if (count == 1) {
            _fireConfetti();
          }
        },
        onLongPress: () => _showQuickMenuDialog(context, type),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-1',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.touch_app,
                    size: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(delay: (type.index * 50).ms);
  }

  Widget _buildSunnahCard(
    BuildContext context,
    PrayerType type,
    String label,
    int count, {
    bool isNafl = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<KazaCubit>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          InteractionUtils.haptic(context);
          if (isNafl) {
            cubit.incrementNafl();
          } else {
            cubit.incrementSunnah(type);
          }
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.1),
                colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.redAccent,
                      onPressed: () {
                        InteractionUtils.haptic(context);
                        cubit.bulkAdd(type, -1);
                      },
                    ),
                    Text(
                      'prayers.edit'.tr(),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: colorScheme.primary,
                      onPressed: () {
                        InteractionUtils.haptic(context);
                        cubit.bulkAdd(type, 1);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(delay: (type.index * 50).ms);
  }

  void _showQuickMenuDialog(BuildContext context, PrayerType type) {
    InteractionUtils.mediumImpact(context);
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<KazaCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'prayers.quickMenu'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'prayers.reduceDebt'.tr(),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      ctx,
                      cubit,
                      type,
                      -1,
                      colorScheme,
                      true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionButton(
                      ctx,
                      cubit,
                      type,
                      -5,
                      colorScheme,
                      true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionButton(
                      ctx,
                      cubit,
                      type,
                      -10,
                      colorScheme,
                      true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCustomAmountField(
                ctx,
                cubit,
                type,
                colorScheme,
                isReduce: true,
              ),
              const Divider(height: 48, thickness: 1),
              Text(
                'prayers.addDebt'.tr(),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      ctx,
                      cubit,
                      type,
                      1,
                      colorScheme,
                      false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionButton(
                      ctx,
                      cubit,
                      type,
                      5,
                      colorScheme,
                      false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionButton(
                      ctx,
                      cubit,
                      type,
                      10,
                      colorScheme,
                      false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCustomAmountField(
                ctx,
                cubit,
                type,
                colorScheme,
                isReduce: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    KazaCubit cubit,
    PrayerType type,
    int amount,
    ColorScheme colorScheme,
    bool isReduce,
  ) {
    return ElevatedButton(
      onPressed: () {
        InteractionUtils.haptic(context);
        cubit.bulkAdd(type, amount);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isReduce
            ? colorScheme.primary.withValues(alpha: 0.2)
            : Colors.redAccent.withValues(alpha: 0.2),
        foregroundColor: isReduce ? colorScheme.primary : Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Text(
        amount > 0 ? '+$amount' : '$amount',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildCustomAmountField(
    BuildContext context,
    KazaCubit cubit,
    PrayerType type,
    ColorScheme colorScheme, {
    required bool isReduce,
  }) {
    final controller = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'bulk_add.enter_amount'.tr(),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            final val = int.tryParse(controller.text);
            if (val != null && val > 0) {
              InteractionUtils.haptic(context);
              cubit.bulkAdd(type, isReduce ? -val : val);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isReduce ? colorScheme.primary : Colors.redAccent,
            foregroundColor: isReduce ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(isReduce ? 'prayers.reduce'.tr() : 'prayers.add'.tr()),
        ),
      ],
    );
  }

  Widget _buildStatsDashboard(
    BuildContext context,
    ColorScheme colorScheme,
    KazaState state,
  ) {
    return Column(
      children: [
        _buildCompletionCard(context, colorScheme, state),
        const SizedBox(height: 16),
        _buildWeeklyActivityCard(context, colorScheme, state),
      ],
    );
  }

  Widget _buildCompletionCard(
    BuildContext context,
    ColorScheme colorScheme,
    KazaState state,
  ) {
    final completionDate = state.expectedCompletionDate;
    final rate = state.dailyAverageRate;
    final dateStr = completionDate != null
        ? DateFormat.yMMMMd(
            IntlUtils.getSafeLocale(context),
          ).format(completionDate)
        : '---';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'stats.estCompletion'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            dateStr,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'stats.dailyAverage'.tr(),
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                '${rate.toStringAsFixed(1)} ${"stats.prayersPerDay".tr()}',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityCard(
    BuildContext context,
    ColorScheme colorScheme,
    KazaState state,
  ) {
    final history = state.history;
    final last7Days = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      final dateOnly = DateTime(date.year, date.month, date.day);
      return history[dateOnly] ?? 0;
    });

    final maxVal = last7Days
        .reduce((a, b) => a > b ? a : b)
        .toDouble()
        .clamp(10.0, 100.0);

    return Container(
      height: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'stats.weeklyActivity'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal + 5,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.now().subtract(
                          Duration(days: 6 - value.toInt()),
                        );
                        return Text(
                          DateFormat.E(
                            IntlUtils.getSafeLocale(context),
                          ).format(date)[0],
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: last7Days.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.toDouble(),
                        color: colorScheme.primary,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 30,
                          color: colorScheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullDayAction(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _showConfirmationDialog(context),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.done_all, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              'prayers.completeDay'.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0);
  }

  void _showConfirmationDialog(BuildContext context) {
    InteractionUtils.mediumImpact(context);
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<KazaCubit>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text('confirmation.title'.tr()),
          content: Text('confirmation.completeDay'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                InteractionUtils.haptic(context);
                cubit.decrementDay();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.black,
              ),
              child: Text('common.confirm'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.help'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'settings.helpKaza'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('library.qaza_rules_content'.tr()),
            const SizedBox(height: 16),
            Text(
              'settings.helpSunnah'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('confirmation.pointsInfo'.tr()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
  }
}
