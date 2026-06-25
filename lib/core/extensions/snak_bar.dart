import 'package:electro_pi_task_manager/core/theming/extensions/color_theme.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide a method for showing a SnackBar.
extension ShowSnackBar on BuildContext {
  /// Shows a SnackBar with the given message.
  ///
  /// [message] is the text to display in the SnackBar.
  /// [isError] determines the background color of the SnackBar. If true, the background color will be [inverseSurface], otherwise [primary].
  /// [background] is an optional parameter to specify a custom background color.
  void showSnackBar(String message, {bool isError = true, Color? background}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: background ?? (isError ? inverseSurface : primary),
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
