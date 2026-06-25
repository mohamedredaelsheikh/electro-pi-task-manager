import '../enums/app_locale.dart';
import '../enums/app_theme_mode.dart';

abstract class SettingsRepository {
  AppThemeMode getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
  AppLocale getLocale();
  Future<void> setLocale(AppLocale locale);
}
