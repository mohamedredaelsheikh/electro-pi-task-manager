import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/app_locale.dart';
import '../../domain/enums/app_theme_mode.dart';
import '../../domain/usecases/get_locale_usecase.dart';
import '../../domain/usecases/get_theme_mode_usecase.dart';
import '../../domain/usecases/set_locale_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetThemeModeUseCase _getThemeMode;
  final SetThemeModeUseCase _setThemeMode;
  final GetLocaleUseCase _getLocale;
  final SetLocaleUseCase _setLocale;

  SettingsCubit({
    required GetThemeModeUseCase getThemeMode,
    required SetThemeModeUseCase setThemeMode,
    required GetLocaleUseCase getLocale,
    required SetLocaleUseCase setLocale,
  })  : _getThemeMode = getThemeMode,
        _setThemeMode = setThemeMode,
        _getLocale = getLocale,
        _setLocale = setLocale,
        super(const SettingsState()) {
    _load();
  }

  void _load() => emit(SettingsState(
        themeMode: _getThemeMode(),
        locale: _getLocale(),
      ));

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(AppLocale locale) async {
    await _setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
