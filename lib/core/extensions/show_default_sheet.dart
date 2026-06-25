import 'package:flutter/material.dart';

extension ShowDefaultSheet on BuildContext {
  Future<T?> showDefaultSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? barrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) => child,
    );
  }
}
