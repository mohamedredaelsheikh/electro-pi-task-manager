import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheClient {
  final Box<String> _box;

  const HiveCacheClient(this._box);

  List<Map<String, dynamic>>? getList(String key) {
    try {
      final raw = _box.get(key);
      if (raw == null) return null;
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  Future<void> putList(String key, List<Map<String, dynamic>> items) =>
      _box.put(key, jsonEncode(items));

  Future<void> remove(String key) => _box.delete(key);
}
