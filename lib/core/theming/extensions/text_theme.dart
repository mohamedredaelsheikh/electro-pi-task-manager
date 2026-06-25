import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to text theme styles.
extension TextThemeEx on BuildContext {
  /// Retrieves the [TextTheme] from the current [Theme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// (44/600)
  TextStyle get displayLarge => textTheme.displayLarge!;

  ///(24/700)
  TextStyle get headlineLarge => textTheme.headlineLarge!;

  ///heading8 (20/600)
  TextStyle get headlineMedium => textTheme.headlineMedium!;

  /// (16/600)
  TextStyle get headlineSmall => textTheme.headlineSmall!;

  ///Xtra-Large (18/600)
  TextStyle get titleLarge => textTheme.titleLarge!;

  ///large/Medium (16/500)
  TextStyle get titleMedium => textTheme.titleMedium!;

  ///medium/bold (16/600)
  TextStyle get bodyLarge => textTheme.bodyLarge!;

  ///medium/medium (14/500)
  TextStyle get bodyMedium => textTheme.bodyMedium!;

  ///medium regular (14/400)
  TextStyle get bodySmall => textTheme.bodySmall!;

  ///(12/500)
  TextStyle get labelMedium => textTheme.labelMedium!;

  TextStyle get labelSmall => textTheme.labelSmall!;
}
