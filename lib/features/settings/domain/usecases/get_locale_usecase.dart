import '../enums/app_locale.dart';
import '../repositories/settings_repository.dart';

class GetLocaleUseCase {
  final SettingsRepository _repository;
  const GetLocaleUseCase(this._repository);

  AppLocale call() => _repository.getLocale();
}
