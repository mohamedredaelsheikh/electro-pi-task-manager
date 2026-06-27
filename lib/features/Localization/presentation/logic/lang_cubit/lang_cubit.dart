import 'package:electro_pi_task_manager/features/Localization/data/models/language_model.dart';
import 'package:electro_pi_task_manager/features/Localization/data/services/lang_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lang_state.dart';

class LangCubit extends Cubit<LangState> {
  LangCubit({required this.langService})
    : super(
        LangInitial(
          currentLanguage: LanguageModel.supportedLanguages.first,
          locale: const Locale('en'),
        ),
      ) {
    _initializeLanguage();
  }

  final LangService langService;

  Future<void> _initializeLanguage() async {
    try {
      final language = await langService.getCurrentLanguage();
      final locale = await langService.loadLocale();
      emit(LangChanged(currentLanguage: language, locale: locale));
    } catch (_) {
      emit(
        LangChanged(
          currentLanguage: LanguageModel.supportedLanguages.first,
          locale: const Locale('en'),
        ),
      );
    }
  }

  Future<void> changeLanguage(LanguageModel language) async {
    if (state.currentLanguage == language) return;

    emit(
      LangLoading(currentLanguage: state.currentLanguage, locale: state.locale),
    );

    try {
      await langService.changeLanguage(language.code);
      emit(
        LangChanged(currentLanguage: language, locale: Locale(language.code)),
      );
    } catch (_) {
      emit(
        LangChanged(
          currentLanguage: state.currentLanguage,
          locale: state.locale,
        ),
      );
    }
  }

  List<LanguageModel> getSupportedLanguages() {
    return langService.getSupportedLanguages();
  }

  bool isSelected(LanguageModel language) {
    return state.currentLanguage == language;
  }
}
