import 'package:electro_pi_task_manager/core/theming/extensions/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extension on [BuildContext] to provide easy access to text theme styles.
extension TextThemeEx on BuildContext {
  /// Retrieves the [TextTheme] from the current [Theme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  //display//////////////////////////////////////////////////////////////////////////////////////
  TextStyle get k52W400DisplaySmall => textTheme.displaySmall!;
  TextStyle get k52W700DisplayLarge => textTheme.displayLarge!;

  //title_regular//////////////////////////////////////////////////////////////////////////////////////
  TextStyle get k14W400TitleRegularSmall => textTheme.titleSmall!;
  TextStyle get k16W400TitleRegularMedium => textTheme.titleMedium!;
  TextStyle get k20W400TitleRegularLarge => textTheme.titleLarge!;

  //title_bold//////////////////////////////////////////////////////////////////////////////////////
  TextStyle get k24W700TitleBoldSmall => textTheme.headlineSmall!;
  TextStyle get k30W700TitleBoldMedium => textTheme.headlineMedium!;
  TextStyle get k38W700TitleBoldLarge => textTheme.headlineLarge!;

  //text_regular//////////////////////////////////////////////////////////////////////////////////////
  ///tertiary, ls 0.28
  TextStyle get k14W400TextRegularSmall => textTheme.labelSmall!;

  /// outline,ls 0.32
  TextStyle get k16W400TextRegularMedium => textTheme.labelMedium!;
  TextStyle get k20W400TextRegularLarge => textTheme.labelLarge!;

  //text_semibold//////////////////////////////////////////////////////////////////////////////////////
  TextStyle get k14W600TextSemiboldSmall => textTheme.bodySmall!;
  TextStyle get k16W600TextSemiboldMedium => textTheme.bodyMedium!;
  TextStyle get k20W600TextSemiboldLarge => textTheme.bodyLarge!;

  //text_bold//////////////////////////////////////////////////////////////////////////////////////
  ///14,w 700, outline, 0.28
  TextStyle get k14W700TextBoldSmall =>
      textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700);

  ///16,w 700, outline, 0.32
  TextStyle get k16W700TextBoldMedium => textTheme.bodyMedium!.copyWith(
    fontWeight: FontWeight.w700,
    color: onSurface,
  );

  ///20,w 700, onSurface, 0.4
  TextStyle get k20W700TextBoldLarge =>
      textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700);

  //caption//////////////////////////////////////////////////////////////////////////////////////
  ///12,w 400, outline, 0.24, (12/16)
  TextStyle get k12W400CaptionRegular => textTheme.labelSmall!.copyWith(
    fontSize: 12.sp,
    color: outline,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.24,
    height: (16 / 12).sp,
  );

  ///12,w 700, outline, 0.24, 12/16
  TextStyle get k12W700CaptionBold => textTheme.labelSmall!.copyWith(
    fontSize: 12.sp,
    color: onSurface,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.24,
    height: (16 / 12).sp,
  );
}
