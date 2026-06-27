import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theming/extensions/color_theme.dart';
import '../../core/theming/extensions/text_theme.dart';

class BottomSheetOptionBar extends StatelessWidget {
  const BottomSheetOptionBar({super.key, required this.title, this.onTapBack});

  final String title;
  final VoidCallback? onTapBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onTapBack != null)
          _SheetIconButton(icon: Icons.arrow_back_rounded, onTap: onTapBack!)
        else
          SizedBox.square(dimension: 36.w),
        Text(
          title,
          style: context.k16W700TextBoldMedium.copyWith(
            color: context.onSurface,
          ),
        ),
        _SheetIconButton(
          icon: Icons.close_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _SheetIconButton extends StatelessWidget {
  const _SheetIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: context.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 18.r, color: context.onSurface),
      ),
    );
  }
}
