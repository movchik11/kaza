class AnalyticsService {
  /// Compares current week (last 7 days) with previous week (7-14 days ago)
  static Map<String, dynamic> compareWeekly(Map<DateTime, int> history) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int currentWeekTotal = 0;
    int previousWeekTotal = 0;

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      currentWeekTotal += history[date] ?? 0;
    }

    for (int i = 7; i < 14; i++) {
      final date = today.subtract(Duration(days: i));
      previousWeekTotal += history[date] ?? 0;
    }

    double percentageChange = 0;
    if (previousWeekTotal > 0) {
      percentageChange =
          ((currentWeekTotal - previousWeekTotal) / previousWeekTotal) * 100;
    } else if (currentWeekTotal > 0) {
      percentageChange = 100; // From 0 to something is 100% gain
    }

    return {
      'currentTotal': currentWeekTotal,
      'previousTotal': previousWeekTotal,
      'percentageChange': percentageChange,
      'isIncrease': currentWeekTotal >= previousWeekTotal,
    };
  }

  /// Gets daily activity for the last 7 days for charts
  static List<int> getLast7DaysActivity(Map<DateTime, int> history) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(
      7,
      (i) => history[today.subtract(Duration(days: 6 - i))] ?? 0,
    );
  }
}
