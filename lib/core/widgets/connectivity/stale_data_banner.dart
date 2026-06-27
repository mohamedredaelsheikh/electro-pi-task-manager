import 'package:electro_pi_task_manager/core/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:toastification/toastification.dart';

class StaleDataBanner extends StatefulWidget {
  const StaleDataBanner({
    super.key,
    required this.staleAt,
    required this.child,
  });

  final DateTime? staleAt;
  final Widget child;

  @override
  State<StaleDataBanner> createState() => _StaleDataBannerState();
}

class _StaleDataBannerState extends State<StaleDataBanner> {
  DateTime? _lastShownFor;

  @override
  void initState() {
    super.initState();
    _maybeShowToast(widget.staleAt);
  }

  @override
  void didUpdateWidget(StaleDataBanner old) {
    super.didUpdateWidget(old);
    _maybeShowToast(widget.staleAt);
  }

  void _maybeShowToast(DateTime? staleAt) {
    if (staleAt == null || staleAt == _lastShownFor) return;
    _lastShownFor = staleAt;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Toaster.showToast(
        description: 'Showing cached data · Updated ${_formatAge(staleAt)}',
        type: ToastificationType.warning,
        duration: const Duration(seconds: 5),
      );
    });
  }

  String _formatAge(DateTime staleAt) {
    final diff = DateTime.now().difference(staleAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
