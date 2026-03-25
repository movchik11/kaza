import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/kaza_cubit.dart';
import '../cubit/kaza_state.dart';
import '../utils/interaction_utils.dart';

class QuranTrackerCard extends StatelessWidget {
  const QuranTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KazaCubit, KazaState>(
      builder: (context, state) {
        final data = state.data;
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.1),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'library.quranProgress'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrackerItem(
                    context,
                    label: 'library.surah'.tr(),
                    value: data.lastQuranSurah,
                    max: 114,
                    onIncrement: () {
                      if (data.lastQuranSurah < 114) {
                        context.read<KazaCubit>().updateQuranProgress(
                          data.lastQuranSurah + 1,
                          data.lastQuranPage,
                        );
                      }
                    },
                    onDecrement: () {
                      if (data.lastQuranSurah > 1) {
                        context.read<KazaCubit>().updateQuranProgress(
                          data.lastQuranSurah - 1,
                          data.lastQuranPage,
                        );
                      }
                    },
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  _buildTrackerItem(
                    context,
                    label: 'library.page'.tr(),
                    value: data.lastQuranPage,
                    max: 604,
                    onIncrement: () {
                      if (data.lastQuranPage < 604) {
                        context.read<KazaCubit>().updateQuranProgress(
                          data.lastQuranSurah,
                          data.lastQuranPage + 1,
                        );
                      }
                    },
                    onDecrement: () {
                      if (data.lastQuranPage > 1) {
                        context.read<KazaCubit>().updateQuranProgress(
                          data.lastQuranSurah,
                          data.lastQuranPage - 1,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildTrackerItem(
    BuildContext context, {
    required String label,
    required int value,
    required int max,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                InteractionUtils.haptic(context);
                onDecrement();
              },
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              color: colorScheme.primary,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                InteractionUtils.haptic(context);
                onIncrement();
              },
              icon: const Icon(Icons.add_circle_outline, size: 20),
              color: colorScheme.primary,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
      ],
    );
  }
}
