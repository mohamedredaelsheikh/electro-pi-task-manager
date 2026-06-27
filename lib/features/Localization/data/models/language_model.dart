class LanguageModel {
  const LanguageModel({
    required this.name,
    required this.code,
    required this.nativeName,
    required this.isRTL,
  });
  final String name;
  final String code;
  final String nativeName;
  final bool isRTL;

  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(
      name: 'English',
      code: 'en',
      nativeName: 'English (US)',
      isRTL: false,
    ),
    LanguageModel(
      name: 'Arabic',
      code: 'ar',
      nativeName: 'العربية',
      isRTL: true,
    ),
  ];

  static LanguageModel fromCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages.first,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'LanguageModel(code: $code, name: $name, isRTL: $isRTL)';
}
