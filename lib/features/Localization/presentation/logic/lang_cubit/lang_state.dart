import 'package:electro_pi_task_manager/features/Localization/data/models/language_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LangState extends Equatable {
  const LangState({required this.currentLanguage, required this.locale});
  final LanguageModel currentLanguage;
  final Locale locale;

  bool get isRTL => currentLanguage.isRTL;
  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;

  @override
  List<Object> get props => [currentLanguage, locale];
}

class LangInitial extends LangState {
  const LangInitial({required super.currentLanguage, required super.locale});
}

class LangChanged extends LangState {
  const LangChanged({required super.currentLanguage, required super.locale});
}

class LangLoading extends LangState {
  const LangLoading({required super.currentLanguage, required super.locale});
}
