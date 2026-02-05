import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import '../widgets/heatmap_widget.dart';

class PrayersTab extends StatefulWidget {
  final KazaRepository repository;
  const PrayersTab({super.key, required this.repository});

  @override
  State<PrayersTab> createState() => _PrayersTabState();
}

class _PrayersTabState extends State<PrayersTab> {
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

  Future<void> _decrement(PrayerType type) async {
    await widget.repository.decrementPrayer(type);
    _refreshData();
  }

  Future<void> _completeFullDay() async {
    await widget.repository.decrementDay();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
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
                  child: Column(
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
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 16,
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
                  _buildProgressHeader(colorScheme),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildPrayerCard(PrayerType.fajr, 'prayers.fajr'.tr()),
                      _buildPrayerCard(PrayerType.dhuhr, 'prayers.dhuhr'.tr()),
                      _buildPrayerCard(PrayerType.asr, 'prayers.asr'.tr()),
                      _buildPrayerCard(
                        PrayerType.maghrib,
                        'prayers.maghrib'.tr(),
                      ),
                      _buildPrayerCard(PrayerType.isha, 'prayers.isha'.tr()),
                      _buildPrayerCard(PrayerType.witr, 'prayers.witr'.tr()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildFullDayAction(colorScheme),
                  const SizedBox(height: 32),
                  HeatmapWidget(repository: widget.repository),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(ColorScheme colorScheme) {
    final progress = _data.totalRemaining > 0 ? 0.0 : 1.0; // Placeholder logic
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
                  _data.totalRemaining.toString(),
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
                  value: progress, // Use the progress variable
                  strokeWidth: 8,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  strokeCap: StrokeCap.round,
                ),
              ),
              const Icon(Icons.auto_graph, size: 24),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildPrayerCard(PrayerType type, String label) {
    final count = _data.getCount(type);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _decrement(type),
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
            ],
          ),
        ),
      ),
    ).animate().scale(delay: (type.index * 50).ms);
  }

  Widget _buildFullDayAction(ColorScheme colorScheme) {
    return InkWell(
      onTap: _completeFullDay,
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
            const Text(
              "Complete Full Day",
              style: TextStyle(
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
}
