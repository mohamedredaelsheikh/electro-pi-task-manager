import 'package:flutter/foundation.dart';

extension ListenableExtensions on Listenable {
  /// Combines multiple listenables into one
  static Listenable merge(List<Listenable?> listenables) {
    return Listenable.merge(listenables.whereType<Listenable>().toList());
  }
}
