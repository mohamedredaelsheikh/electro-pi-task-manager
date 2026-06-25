import 'package:electro_pi_task_manager/core/language/app_localizations.dart';
import 'package:flutter/material.dart';

extension LocalizationExtension on BuildContext {
  S get getLang => S.of(this);

  bool get isRTL => Localizations.localeOf(this).languageCode == 'ar';

  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;

  String get currentLanguageCode => Localizations.localeOf(this).languageCode;
}
