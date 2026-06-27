import 'package:electro_pi_task_manager/core/extensions/localization.dart';
import 'package:electro_pi_task_manager/core/theming/extensions/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfflineEmptyState extends StatelessWidget {
  const OfflineEmptyState({
    super.key,
    required this.onRetry,
    this.sliver = false,
  });

  final VoidCallback onRetry;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off_rounded, size: 80.r, color: Theme.of(context).colorScheme.primary),
        SizedBox(height: 16.r),
        Text(
          context.getLang.no_internet_connection,
          style: context.k20W600TextSemiboldLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.r),
        Text(
          context.getLang.check_your_connection,
          style: context.k16W400TextRegularMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.r),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.r),
          child: FilledButton(
            onPressed: onRetry,
            child: Text(context.getLang.retry),
          ),
        ),
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
