import 'package:electro_pi_task_manager/core/extensions/localization.dart';
import 'package:electro_pi_task_manager/core/language/app_localizations.dart';
import 'package:electro_pi_task_manager/core/theming/extensions/color_theme.dart';
import 'package:electro_pi_task_manager/core/theming/extensions/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.sliver = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool sliver;

  bool _isNetworkError() {
    return message == S.current.no_internet_connection ||
        message == S.current.timeout_error;
  }

  @override
  Widget build(BuildContext context) {
    final isNetwork = _isNetworkError();

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isNetwork)
          Icon(
            Icons.wifi_off_rounded,
            size: 80.r,
            color: context.primary,
          )
        else
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              color: context.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 60.r,
              color: context.error,
            ),
          ),
        SizedBox(height: 16.r),
        Text(
          isNetwork ? context.getLang.no_internet_connection : context.getLang.oops,
          style: context.k20W600TextSemiboldLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.r),
        Text(
          isNetwork ? context.getLang.check_your_connection : message,
          style: context.k16W400TextRegularMedium,
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          SizedBox(height: 24.r),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.r),
            child: FilledButton(
              onPressed: onRetry,
              child: Text(context.getLang.retry),
            ),
          ),
        ],
      ],
    );

    if (sliver) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.r),
            child: content,
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.r),
        child: content,
      ),
    );
  }
}
