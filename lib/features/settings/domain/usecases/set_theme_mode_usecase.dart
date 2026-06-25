import '../enums/app_theme_mode.dart';
import '../repositories/settings_repository.dart';

class SetThemeModeUseCase {
  final SettingsRepository _repository;
  const SetThemeModeUseCase(this._repository);

  Future<void> call(AppThemeMode mode) => _repository.setThemeMode(mode);
}
