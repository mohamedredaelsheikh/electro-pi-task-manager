import 'package:flutter/material.dart';

enum AppLocale { en, ar }

extension AppLocaleX on AppLocale {
  Locale get locale => switch (this) {
    AppLocale.en => const Locale('en'),
    AppLocale.ar => const Locale('ar'),
  };
}
