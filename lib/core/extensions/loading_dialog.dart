import 'package:electro_pi_task_manager/core/theming/extensions/color_theme.dart';
import 'package:flutter/material.dart';

extension LoadingDialog on BuildContext {
  Future<void> showLoadingDialog() async {
    await showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator(color: context.primary)),
      ),
    );
  }
}
