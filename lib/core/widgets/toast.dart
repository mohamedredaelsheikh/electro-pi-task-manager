import 'package:electro_pi_task_manager/core/theming/themes.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class Toaster {
  static void showToast({
    required String description,
    ToastificationType type = ToastificationType.error,
    Duration? duration,
  }) {
    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      description: Text(
        description,
        style: lightTheme.textTheme.bodyMedium?.copyWith(
          color: lightTheme.colorScheme.surface,
        ),
      ),
      alignment: AlignmentDirectional.bottomCenter,
      autoCloseDuration: duration ?? const Duration(seconds: 4),
    );
  }
}
