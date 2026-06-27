import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:electro_pi_task_manager/core/extensions/localization.dart';
import 'package:electro_pi_task_manager/core/language/app_localizations.dart';
import 'package:electro_pi_task_manager/core/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  late final StreamSubscription<List<ConnectivityResult>> _sub;
  ToastificationItem? _offlineToast;
  bool _isOffline = false;
  late S _strings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _strings = context.getLang;
  }

  @override
  void initState() {
    super.initState();
    _sub = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);

    if (!hasConnection && !_isOffline) {
      _isOffline = true;
      _offlineToast = toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        description: Text(_strings.no_internet_connection),
        alignment: AlignmentDirectional.bottomCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else if (hasConnection && _isOffline) {
      _isOffline = false;
      _dismissOfflineToast();
      Toaster.showToast(
        description: _strings.back_online,
        type: ToastificationType.success,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _dismissOfflineToast() {
    if (_offlineToast != null) {
      toastification.dismiss(_offlineToast!);
      _offlineToast = null;
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    _dismissOfflineToast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
