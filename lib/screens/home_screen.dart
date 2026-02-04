import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import '../widgets/prayer_card.dart';
import '../widgets/heatmap_widget.dart';

class HomeScreen extends StatefulWidget {
  final KazaRepository repository;
  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late KazaModel _data;
  Map<DateTime, int> _history = {};

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _data = widget.repository.getKazaData();
      _history = widget.repository.getHistory();
    });
  }

  void _decrement(PrayerType type) {
    // Optimistic update
    setState(() {
      int newValue = _data.getCount(type) - 1;
      if (newValue < 0) newValue = 0;

      switch (type) {
        case PrayerType.fajr:
          _data = _data.copyWith(fajr: newValue);
          break;
        case PrayerType.dhuhr:
          _data = _data.copyWith(dhuhr: newValue);
          break;
        case PrayerType.asr:
          _data = _data.copyWith(asr: newValue);
          break;
        case PrayerType.maghrib:
          _data = _data.copyWith(maghrib: newValue);
          break;
        case PrayerType.isha:
          _data = _data.copyWith(isha: newValue);
          break;
        case PrayerType.witr:
          _data = _data.copyWith(witr: newValue);
          break;
      }

      // Update local history for immediate feedback
      final now = DateTime.now();
      final key = DateTime(now.year, now.month, now.day);
      _history[key] = (_history[key] ?? 0) + 1;
    });

    // Save in background
    widget.repository.decrementPrayer(type);
  }

  void _decrementDay() async {
    // Optimistic update
    setState(() {
      _data = _data.copyWith(
        fajr: (_data.fajr - 1).clamp(0, 999999),
        dhuhr: (_data.dhuhr - 1).clamp(0, 999999),
        asr: (_data.asr - 1).clamp(0, 999999),
        maghrib: (_data.maghrib - 1).clamp(0, 999999),
        isha: (_data.isha - 1).clamp(0, 999999),
        witr: (_data.witr - 1).clamp(0, 999999),
      );

      final now = DateTime.now();
      final key = DateTime(now.year, now.month, now.day);
      _history[key] = (_history[key] ?? 0) + 6;
    });

    await widget.repository.decrementDay();
  }

  String get _estimatedCompletion {
    if (_history.isEmpty) return "Unknown";

    // Calculate average prayers per day over last 7 days
    int total = 0;
    int days = 0;
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final d = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      if (_history.containsKey(d)) {
        total += _history[d]!;
        days++;
      }
    }

    if (total == 0) return "Start praying to see estimate";

    final avgPerDay = total / (days == 0 ? 1 : days); // Avoid div by zero
    if (avgPerDay < 0.1) return "Start praying to see estimate";

    final daysRemaining = _data.totalRemaining / avgPerDay;
    final finishDate = DateTime.now().add(Duration(days: daysRemaining.ceil()));

    // Format Month Year
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[finishDate.month - 1]} ${finishDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = _data.progress;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _decrementDay,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.calendar_today),
        label: const Text("Completed Full Day (+6)"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1F2937),
                        const Color(0xFF111827),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withAlpha(13)),
                  ),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 12.0,
                        animation: true,
                        percent: progress,
                        center: Text(
                          "${(progress * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: colorScheme.primary,
                        backgroundColor: colorScheme.surface,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Progress",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${_data.totalRemaining} prayers remaining",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Finish by: $_estimatedCompletion",
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -0.2, end: 0).fadeIn(),

              const SizedBox(height: 20),

              // Grid Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    PrayerCard(
                      title: 'Fajr',
                      count: _data.fajr,
                      color: Colors.orangeAccent,
                      onTap: () => _decrement(PrayerType.fajr),
                    ),
                    PrayerCard(
                      title: 'Dhuhr',
                      count: _data.dhuhr,
                      color: Colors.yellowAccent,
                      onTap: () => _decrement(PrayerType.dhuhr),
                    ),
                    PrayerCard(
                      title: 'Asr',
                      count: _data.asr,
                      color: Colors.orange,
                      onTap: () => _decrement(PrayerType.asr),
                    ),
                    PrayerCard(
                      title: 'Maghrib',
                      count: _data.maghrib,
                      color: Colors.redAccent,
                      onTap: () => _decrement(PrayerType.maghrib),
                    ),
                    PrayerCard(
                      title: 'Isha',
                      count: _data.isha,
                      color: Colors.indigoAccent,
                      onTap: () => _decrement(PrayerType.isha),
                    ),
                    PrayerCard(
                      title: 'Witr',
                      count: _data.witr,
                      color: Colors.purpleAccent,
                      onTap: () => _decrement(PrayerType.witr),
                    ),
                  ].animate(interval: 50.ms).fadeIn().scale(),
                ),
              ),

              const SizedBox(height: 30),

              // History Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: HeatmapWidget(history: _history),
              ),

              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }
}
