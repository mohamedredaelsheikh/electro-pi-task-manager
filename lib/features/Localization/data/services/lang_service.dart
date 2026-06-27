import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_model.dart';

class LangService {
  LangService({required this.prefs});

  final SharedPreferences prefs;
  static const _languageKey = 'language';

  Future<String> getSavedLanguageCode() async {
    final saved = prefs.getString(_languageKey);
    if (saved != null) return saved;

    final deviceCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final isSupported =
        LanguageModel.supportedLanguages.any((l) => l.code == deviceCode);
    return isSupported ? deviceCode : 'en';
  }

  Future<void> saveLanguageCode(String code) async {
    await prefs.setString(_languageKey, code);
  }

  Future<Locale> loadLocale() async {
    final code = await getSavedLanguageCode();
    return Locale(code);
  }

  Future<void> changeLanguage(String code) async {
    await saveLanguageCode(code);
  }

  Future<LanguageModel> getCurrentLanguage() async {
    final code = await getSavedLanguageCode();
    return LanguageModel.fromCode(code);
  }

  Future<bool> isRTL() async {
    final language = await getCurrentLanguage();
    return language.isRTL;
  }

  List<LanguageModel> getSupportedLanguages() {
    return LanguageModel.supportedLanguages;
  }
}
