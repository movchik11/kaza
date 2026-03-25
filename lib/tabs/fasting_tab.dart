import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../cubit/kaza_cubit.dart';
import '../cubit/kaza_state.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import '../utils/interaction_utils.dart';
import 'package:confetti/confetti.dart';
import 'package:adhan/adhan.dart';
import '../services/prayer_times_service.dart';

class FastingTab extends StatefulWidget {
  final KazaRepository repository;
  const FastingTab({super.key, required this.repository});

  @override
  State<FastingTab> createState() => _FastingTabState();
}

class _FastingTabState extends State<FastingTab> {
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

    return BlocBuilder<KazaCubit, KazaState>(
      builder: (context, state) {
        final data = state.data;
        final progress = data.initialFasting > 0
            ? (1 - (data.fasting / data.initialFasting)).clamp(0.0, 1.0)
            : 0.0;

        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'fasting.title'.tr(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'fasting.subtitle'.tr(),
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<PrayerTimes?>(
                        future: PrayerTimesService.getPrayerTimes(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const SizedBox.shrink();
                          }
                          final pt = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTimeCard(
                                    context,
                                    'fasting_rules.suhoorEnds'.tr(),
                                    DateFormat.Hm().format(pt.fajr),
                                    Icons.wb_twilight,
                                    colorScheme,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTimeCard(
                                    context,
                                    'fasting_rules.iftarBegins'.tr(),
                                    DateFormat.Hm().format(pt.maghrib),
                                    Icons.nightlight_round,
                                    colorScheme,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      _buildModeToggle(context, colorScheme),
                      const SizedBox(height: 24),
                      _isTrackingKaza
                          ? _buildKazaView(context, colorScheme, data, progress)
                          : _buildVoluntaryView(context, colorScheme, state),
                      const SizedBox(height: 16),
                      _buildInfoCardsList(context, colorScheme),
                    ],
                  ),
                ),
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

  Widget _buildKazaView(
    BuildContext context,
    ColorScheme colorScheme,
    KazaModel data,
    double progress,
  ) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Center(
          child: GestureDetector(
            onLongPress: () => _showBulkAddDialog(context),
            child: CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 20.0,
              animation: true,
              percent: progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.fasting.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48.0,
                    ),
                  ),
                  Text(
                    'fasting.remaining'.tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: colorScheme.primary,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            ),
          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'fasting.remaining'.tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    data.fasting.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _showConfirmationDialog(context, data),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'fasting.completeDay'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildVoluntaryView(
    BuildContext context,
    ColorScheme colorScheme,
    KazaState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                final dayStr =
                    "\${day.year}-\${day.month.toString().padLeft(2, '0')}-\${day.day.toString().padLeft(2, '0')}";
                return state.voluntaryFasts.any(
                  (d) =>
                      "\${d.year}-\${d.month.toString().padLeft(2, '0')}-\${d.day.toString().padLeft(2, '0')}" ==
                      dayStr,
                );
              },
              onDaySelected: (selectedDay, focusedDay) {
                InteractionUtils.haptic(context);
                context.read<KazaCubit>().toggleVoluntaryFast(selectedDay);
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  );
                },
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          Text(
            'prayers.sunnahSubtitle'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, KazaModel data) {
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
                if (data.fasting == 1) {
                  _confettiController.play();
                }
                cubit.decrementPrayer(PrayerType.fasting);
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

  void _showBulkAddDialog(BuildContext context) {
    InteractionUtils.mediumImpact(context);
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<KazaCubit>();

    showModalBottomSheet(
      context: context,
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
            children: [
              Text(
                'bulk_add.title'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBulkButton(ctx, cubit, 10, colorScheme),
                  _buildBulkButton(ctx, cubit, 30, colorScheme),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                '— OR —',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildCustomAmountField(ctx, cubit, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomAmountField(
    BuildContext context,
    KazaCubit cubit,
    ColorScheme colorScheme,
  ) {
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
              final currentCount = cubit.state.data.fasting;
              if (currentCount <= val && currentCount > 0) {
                _confettiController.play();
              }
              cubit.bulkAdd(PrayerType.fasting, -val);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text('bulk_add.add'.tr()),
        ),
      ],
    );
  }

  Widget _buildBulkButton(
    BuildContext context,
    KazaCubit cubit,
    int amount,
    ColorScheme colorScheme,
  ) {
    return ElevatedButton(
      onPressed: () {
        InteractionUtils.haptic(context);
        cubit.bulkAdd(PrayerType.fasting, amount);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text('+$amount'),
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    ColorScheme color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardsList(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildInfoCard(
            context,
            'fasting_rules.duasTitle'.tr(),
            Icons.menu_book,
            colorScheme,
            () => _showDuasSheet(context, colorScheme),
          ),
          const SizedBox(width: 12),
          _buildInfoCard(
            context,
            'fasting_rules.rulesTitle'.tr(),
            Icons.rule,
            colorScheme,
            () => _showRulesSheet(context, colorScheme),
          ),
          const SizedBox(width: 12),
          _buildInfoCard(
            context,
            'fasting_rules.forbiddenTitle'.tr(),
            Icons.do_not_disturb_alt,
            colorScheme,
            () => _showForbiddenSheet(context, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    IconData icon,
    ColorScheme color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showDuasSheet(BuildContext context, ColorScheme color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: color.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'fasting_rules.duasTitle'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildDuaSection(
              color,
              'fasting_rules.suhoorDuaTitle'.tr(),
              'fasting_rules.suhoorDuaArabic'.tr(),
              'fasting_rules.suhoorDuaTransliteration'.tr(),
              'fasting_rules.suhoorDuaTranslation'.tr(),
            ),
            const Divider(height: 32),
            _buildDuaSection(
              color,
              'fasting_rules.iftarDuaTitle'.tr(),
              'fasting_rules.iftarDuaArabic'.tr(),
              'fasting_rules.iftarDuaTransliteration'.tr(),
              'fasting_rules.iftarDuaTranslation'.tr(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaSection(
    ColorScheme color,
    String title,
    String arabic,
    String trans,
    String translation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          arabic,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 22, height: 1.5),
        ),
        const SizedBox(height: 12),
        Text(
          trans,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(translation, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showRulesSheet(BuildContext context, ColorScheme color) {
    _showTextSheet(
      context,
      color,
      'fasting_rules.rulesTitle'.tr(),
      'fasting_rules.rulesBody'.tr(),
    );
  }

  void _showForbiddenSheet(BuildContext context, ColorScheme color) {
    _showTextSheet(
      context,
      color,
      'fasting_rules.forbiddenTitle'.tr(),
      'fasting_rules.forbiddenBody'.tr(),
    );
  }

  void _showTextSheet(
    BuildContext context,
    ColorScheme color,
    String title,
    String body,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: color.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(body, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
