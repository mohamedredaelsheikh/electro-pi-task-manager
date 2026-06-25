import '../enums/app_locale.dart';
import '../repositories/settings_repository.dart';

class SetLocaleUseCase {
  final SettingsRepository _repository;
  const SetLocaleUseCase(this._repository);

  Future<void> call(AppLocale locale) => _repository.setLocale(locale);
}
