import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/app_theme_mode.dart';
import '../../domain/usecases/get_theme_mode_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetThemeModeUseCase _getThemeMode;
  final SetThemeModeUseCase _setThemeMode;

  SettingsCubit({
    required GetThemeModeUseCase getThemeMode,
    required SetThemeModeUseCase setThemeMode,
  })  : _getThemeMode = getThemeMode,
        _setThemeMode = setThemeMode,
        super(const SettingsState()) {
    _load();
  }

  void _load() => emit(SettingsState(themeMode: _getThemeMode()));

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }
}
