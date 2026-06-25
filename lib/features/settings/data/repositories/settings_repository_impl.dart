import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/enums/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _themeKey = 'theme_mode';

  const SettingsRepositoryImpl(this._prefs);

  @override
  AppThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey);
    return switch (value) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) {
    final value = switch (mode) {
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
      AppThemeMode.system => 'system',
    };
    return _prefs.setString(_themeKey, value);
  }
}
