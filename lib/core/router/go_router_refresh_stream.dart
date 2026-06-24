import 'dart:async';
import 'package:flutter/foundation.dart';

/// Bridges a Bloc/Cubit stream to a GoRouter refreshListenable so the
/// redirect guard re-runs whenever auth (or any other cubit) emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
