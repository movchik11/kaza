import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../repositories/kaza_repository.dart';
import '../models/kaza_model.dart';

class FastingTab extends StatefulWidget {
  final KazaRepository repository;
  const FastingTab({super.key, required this.repository});

  @override
  State<FastingTab> createState() => _FastingTabState();
}

class _FastingTabState extends State<FastingTab> {
  late KazaModel _data;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _data = widget.repository.getKazaData();
    });
  }

  Future<void> _decrement() async {
    await widget.repository.decrementPrayer(PrayerType.fasting);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = _data.initialFasting > 0
        ? (1 - (_data.fasting / _data.initialFasting)).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              const Spacer(),
              Center(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 20.0,
                  animation: true,
                  percent: progress,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _data.fasting.toString(),
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
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
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
                          _data.fasting.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _decrement,
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
          ),
        ),
      ),
    );
  }
}
