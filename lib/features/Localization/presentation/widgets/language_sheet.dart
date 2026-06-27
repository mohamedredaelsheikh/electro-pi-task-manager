import 'package:electro_pi_task_manager/core/extensions/capital_first.dart';
import 'package:electro_pi_task_manager/core/extensions/localization.dart';
import 'package:electro_pi_task_manager/core/theming/extensions/color_theme.dart';
import 'package:electro_pi_task_manager/core/theming/extensions/text_theme.dart';
import 'package:electro_pi_task_manager/core/widgets/bottom_sheet_option_bar.dart';
import 'package:electro_pi_task_manager/features/Localization/data/models/language_model.dart';
import 'package:electro_pi_task_manager/features/Localization/presentation/logic/lang_cubit/lang_cubit.dart';
import 'package:electro_pi_task_manager/features/Localization/presentation/logic/lang_cubit/lang_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        final langCubit = context.read<LangCubit>();
        final languages = langCubit.getSupportedLanguages();

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ColoredBox(
          color: isDark ? context.primary : Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BottomSheetOptionBar(
                    title: context.getLang.languages.firstCapital() ?? '',
                  ),
                  SizedBox(height: 16.h),
                  ...languages.map(
                    (language) => InkWell(
                      onTap: () async {
                        await langCubit.changeLanguage(language);
                        if (context.mounted) Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: LanguageType(
                          language: language,
                          isSelected: langCubit.isSelected(language),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LanguageType extends StatelessWidget {
  const LanguageType({
    super.key,
    required this.language,
    required this.isSelected,
  });

  final LanguageModel language;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          language.nativeName,
          style: isSelected
              ? context.k16W700TextBoldMedium.copyWith(color: context.onSurface)
              : context.k16W400TextRegularMedium.copyWith(
                  color: context.onSurface,
                ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: isSelected
              ? Icon(
                  Icons.check_circle,
                  key: const ValueKey('selected'),
                  size: 24.r,
                  color: context.primary,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  key: const ValueKey('unselected'),
                  size: 24.r,
                  color: context.outlineVariant,
                ),
        ),
      ],
    );
  }
}
