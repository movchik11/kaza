import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../cubit/tasbih_cubit.dart';
import '../cubit/tasbih_state.dart';
import '../services/interaction_service.dart';

class TasbihTab extends StatefulWidget {
  const TasbihTab({super.key});

  @override
  State<TasbihTab> createState() => _TasbihTabState();
}

class _TasbihTabState extends State<TasbihTab> {
  void _handleTap(BuildContext context, TasbihState state, TasbihCubit cubit) {
    final nextCount = state.count + 1;
    if (nextCount == state.target) {
      InteractionService.success(); // Heavy vibration/sound when reaching target
    } else {
      InteractionService.tap();
    }
    cubit.increment();
  }

  void _showTargetOptions(BuildContext context, TasbihCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => _TargetOptionsSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TasbihCubit, TasbihState>(
          builder: (context, state) {
            final cubit = context.read<TasbihCubit>();
            final progress = state.target > 0
                ? (state.count / state.target).clamp(0.0, 1.0)
                : 0.0;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handleTap(context, state, cubit),
              child: Column(
                children: [
                  // Header Dashboard
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "tasbih.title".tr(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            InteractionService.error();
                            cubit.resetCount();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          tooltip: "tasbih.reset".tr(),
                        ),
                      ],
                    ),
                  ),

                  // Glassmorphism Info Panel
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: InkWell(
                      onTap: () => _showTargetOptions(context, cubit),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoStat(
                              "tasbih.target".tr(),
                              "${state.target}",
                              colorScheme,
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: colorScheme.primary.withValues(alpha: 0.2),
                            ),
                            _buildInfoStat(
                              "tasbih.laps".tr(),
                              "${state.laps}",
                              colorScheme,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Main Counter with Circular Progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 140.0,
                        lineWidth: 12.0,
                        percent: progress,
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                        progressColor: colorScheme.primary,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: 300,
                      ),
                      Container(
                            width: 230,
                            height: 230,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${state.count}',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          )
                          .animate(key: ValueKey(state.count))
                          .scale(
                            duration: 150.ms,
                            curve: Curves.easeOut,
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                          ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  Text(
                    "tasbih.hint".tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoStat(String title, String value, ColorScheme color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: color.onSurface.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TargetOptionsSheet extends StatelessWidget {
  final TasbihCubit cubit;

  const _TargetOptionsSheet({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "tasbih.target".tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _targetBtn(context, 33, colorScheme),
              _targetBtn(context, 99, colorScheme),
              _targetBtn(context, 100, colorScheme),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _enterCustomTarget(context),
            icon: const Icon(Icons.edit),
            label: Text("tasbih.customTarget".tr()),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _targetBtn(BuildContext context, int target, ColorScheme color) {
    final isSelected = cubit.state.target == target;
    return InkWell(
      onTap: () {
        InteractionService.tap();
        cubit.setTarget(target);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary
              : color.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.primary.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            '$target',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSelected ? color.onPrimary : color.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _enterCustomTarget(BuildContext context) {
    final ctrl = TextEditingController();
    Navigator.pop(context); // Close the options sheet first

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("tasbih.enterTarget".tr()),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("tasbih.cancel".tr()),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text);
              if (val != null && val > 0) {
                cubit.setTarget(val);
                Navigator.pop(ctx);
              }
            },
            child: Text("tasbih.save".tr()),
          ),
        ],
      ),
    );
  }
}
