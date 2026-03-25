import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class IntlUtils {
  static String getSafeLocale(BuildContext context) {
    final languageCode = context.locale.languageCode;
    // 'tk' (Turkmen) is often unsupported by the intl package's standard data
    if (languageCode == 'tk') {
      return 'en';
    }
    return languageCode;
  }
}
