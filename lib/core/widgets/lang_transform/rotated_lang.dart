import 'package:electro_pi_task_manager/core/widgets/lang_transform/directional_widget.dart';
import 'package:flutter/material.dart';

class RotatedLang extends DirectionalWidget {
  const RotatedLang({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isRTL(context)) {
      return RotatedBox(quarterTurns: 2, child: child);
    } else {
      return child;
    }
  }
}
