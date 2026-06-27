import 'package:electro_pi_task_manager/core/widgets/lang_transform/directional_widget.dart';
import 'package:flutter/material.dart';

class FlippableLang extends DirectionalWidget {
  const FlippableLang({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(isRTL(context) ? -1.0 : 1.0, 1.0, 1.0),
      child: child,
    );
  }
}
