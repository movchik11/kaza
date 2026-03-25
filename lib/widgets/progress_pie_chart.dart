import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/kaza_model.dart';

class ProgressPieChart extends StatelessWidget {
  final KazaModel data;

  const ProgressPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: _showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    final double total = data.totalInitial.toDouble();
    if (total == 0) return [];

    final List<Map<String, dynamic>> prayers = [
      {'name': 'Fajr', 'value': data.fajr, 'color': Colors.blue},
      {'name': 'Dhuhr', 'value': data.dhuhr, 'color': Colors.orange},
      {'name': 'Asr', 'value': data.asr, 'color': Colors.amber},
      {'name': 'Maghrib', 'value': data.maghrib, 'color': Colors.red},
      {'name': 'Isha', 'value': data.isha, 'color': Colors.indigo},
      {'name': 'Witr', 'value': data.witr, 'color': Colors.purple},
    ];

    return prayers.map((p) {
      final double value = p['value'].toDouble();
      final double percentage = (value / total) * 100;

      return PieChartSectionData(
        color: p['color'],
        value: value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
