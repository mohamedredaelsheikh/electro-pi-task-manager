import '../enums/app_theme_mode.dart';
import '../repositories/settings_repository.dart';

class GetThemeModeUseCase {
  final SettingsRepository _repository;
  const GetThemeModeUseCase(this._repository);

  AppThemeMode call() => _repository.getThemeMode();
}
