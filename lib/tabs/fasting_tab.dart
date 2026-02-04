import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';

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
      // No specific history tracked for fasting tab isolated yet, but can add later
    });
  }

  void _decrementFasting() {
    setState(() {
      int newValue = _data.fasting - 1;
      if (newValue < 0) newValue = 0;
      _data = _data.copyWith(fasting: newValue);
    });
    // Optimistic update done, save to repo
    widget.repository.decrementPrayer(PrayerType.fasting);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initial = _data.initialFasting == 0 ? 1 : _data.initialFasting;
    final progress = (1 - (_data.fasting / initial)).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Text(
                "fastingYears".tr(), // Reusing key loosely or create new title
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn().moveY(begin: -10, end: 0),

              const SizedBox(height: 40),

              // Progress
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
                        "${(progress * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                        ),
                      ),
                      Text(
                        "${_data.fasting} left",
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                ),
              ).animate().scale(),

              const SizedBox(height: 60),

              // Action Button
              ElevatedButton.icon(
                onPressed: _decrementFasting,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  "Complete 1 Fast",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
