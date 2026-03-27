import 'package:hijri/hijri_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

class HijriHoliday {
  final String nameKey;
  final int daysUntil;
  final DateTime? date;

  HijriHoliday(this.nameKey, this.daysUntil, {this.date});
}

class HijriUtils {
  static String getFormattedHijriDate(DateTime date) {
    final hDate = HijriCalendar.fromDate(date);
    // Use EasyLocalization keys for months to ensure dynamic translation (ru / tk)
    final monthKey = 'calendar.months.${hDate.hMonth}';
    return '${hDate.hDay} ${monthKey.tr()} ${hDate.hYear}';
  }

  static List<HijriHoliday> getAllHolidays(int hijriYear) {
    final List<HijriHoliday> holidays = [];
    final holidayDates = {
      'calendar.holidays.ramadan_start': [9, 1],
      'calendar.holidays.eid_al_fitr': [10, 1],
      'calendar.holidays.arafah': [12, 9],
      'calendar.holidays.eid_al_adha': [12, 10],
      'calendar.holidays.new_year': [1, 1],
      'calendar.holidays.ashura': [1, 10],
      'calendar.holidays.mawlid': [3, 12],
    };

    holidayDates.forEach((key, value) {
      final hDate = HijriCalendar();
      hDate.hYear = hijriYear;
      hDate.hMonth = value[0];
      hDate.hDay = value[1];
      holidays.add(
        HijriHoliday(
          key,
          0,
          date: hDate.hijriToGregorian(hijriYear, value[0], value[1]),
        ),
      );
    });

    holidays.sort((a, b) => a.date!.compareTo(b.date!));
    return holidays;
  }

  static HijriHoliday? getNextHoliday(DateTime from) {
    // Iterate securely up to 365 days to find the exactly next Islamic Holiday
    for (int i = 0; i <= 365; i++) {
      final date = from.add(Duration(days: i));
      final hDate = HijriCalendar.fromDate(date);

      if (hDate.hMonth == 9 && hDate.hDay == 1) {
        return HijriHoliday('calendar.holidays.ramadan_start', i, date: date);
      }
      if (hDate.hMonth == 10 && hDate.hDay == 1) {
        return HijriHoliday('calendar.holidays.eid_al_fitr', i, date: date);
      }
      if (hDate.hMonth == 12 && hDate.hDay == 9) {
        return HijriHoliday('calendar.holidays.arafah', i, date: date);
      }
      if (hDate.hMonth == 12 && hDate.hDay == 10) {
        return HijriHoliday('calendar.holidays.eid_al_adha', i, date: date);
      }
      if (hDate.hMonth == 1 && hDate.hDay == 1) {
        return HijriHoliday('calendar.holidays.new_year', i, date: date);
      }
      if (hDate.hMonth == 1 && hDate.hDay == 10) {
        return HijriHoliday('calendar.holidays.ashura', i, date: date);
      }
      if (hDate.hMonth == 3 && hDate.hDay == 12) {
        return HijriHoliday('calendar.holidays.mawlid', i, date: date);
      }
    }
    return null;
  }
}
