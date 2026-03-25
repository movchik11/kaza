import 'package:hijri/hijri_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

class HijriHoliday {
  final String nameKey;
  final int daysUntil;

  HijriHoliday(this.nameKey, this.daysUntil);
}

class HijriUtils {
  static String getFormattedHijriDate(DateTime date) {
    final hDate = HijriCalendar.fromDate(date);
    // Use EasyLocalization keys for months to ensure dynamic translation (ru / tk)
    final monthKey = 'calendar.months.${hDate.hMonth}';
    return '${hDate.hDay} ${monthKey.tr()} ${hDate.hYear}';
  }

  static HijriHoliday? getNextHoliday(DateTime from) {
    // Iterate securely up to 365 days to find the exactly next Islamic Holiday
    for (int i = 0; i <= 365; i++) {
      final date = from.add(Duration(days: i));
      final hDate = HijriCalendar.fromDate(date);

      if (hDate.hMonth == 9 && hDate.hDay == 1) {
        return HijriHoliday('calendar.holidays.ramadan_start', i);
      }
      if (hDate.hMonth == 10 && hDate.hDay == 1) {
        return HijriHoliday('calendar.holidays.eid_al_fitr', i);
      }
      if (hDate.hMonth == 12 && hDate.hDay == 9) {
        return HijriHoliday('calendar.holidays.arafah', i);
      }
      if (hDate.hMonth == 12 && hDate.hDay == 10) {
        return HijriHoliday('calendar.holidays.eid_al_adha', i);
      }
      if (hDate.hMonth == 1 && hDate.hDay == 1) {
        return HijriHoliday('calendar.holidays.new_year', i);
      }
      if (hDate.hMonth == 1 && hDate.hDay == 10) {
        return HijriHoliday('calendar.holidays.ashura', i);
      }
      if (hDate.hMonth == 3 && hDate.hDay == 12) {
        return HijriHoliday('calendar.holidays.mawlid', i);
      }
    }
    return null;
  }
}
