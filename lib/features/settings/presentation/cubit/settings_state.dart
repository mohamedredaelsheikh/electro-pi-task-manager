import '../../domain/enums/app_theme_mode.dart';

class SettingsState {
  final AppThemeMode themeMode;

  const SettingsState({this.themeMode = AppThemeMode.system});

  SettingsState copyWith({AppThemeMode? themeMode}) =>
      SettingsState(themeMode: themeMode ?? this.themeMode);
}
