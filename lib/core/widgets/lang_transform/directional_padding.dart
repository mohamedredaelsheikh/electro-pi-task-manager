import 'package:electro_pi_task_manager/core/widgets/lang_transform/directional_widget.dart';
import 'package:flutter/material.dart';

class DirectionalPadding extends DirectionalWidget {
  const DirectionalPadding({
    super.key,
    required this.child,
    this.start = 0,
    this.end = 0,
    this.top = 0,
    this.bottom = 0,
  });

  final Widget child;
  final double start;
  final double end;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
