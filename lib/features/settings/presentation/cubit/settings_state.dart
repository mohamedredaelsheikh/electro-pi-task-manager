import '../../domain/enums/app_locale.dart';
import '../../domain/enums/app_theme_mode.dart';

class SettingsState {
  final AppThemeMode themeMode;
  final AppLocale locale;

  const SettingsState({
    this.themeMode = AppThemeMode.system,
    this.locale = AppLocale.en,
  });

  SettingsState copyWith({AppThemeMode? themeMode, AppLocale? locale}) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}
