import 'package:home_widget/home_widget.dart';
import '../models/kaza_model.dart';

class WidgetService {
  static const String _androidWidgetName = 'KazaWidgetProvider';
  static const String _iosWidgetName = 'KazaWidget';

  static Future<void> updateWidget(KazaModel data) async {
    try {
      await HomeWidget.saveWidgetData<int>(
        'total_remaining',
        data.totalRemaining,
      );
      await HomeWidget.saveWidgetData<int>(
        'current_streak',
        data.currentStreak,
      );

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
    } catch (e) {
      // Widget update failed
    }
  }
}
