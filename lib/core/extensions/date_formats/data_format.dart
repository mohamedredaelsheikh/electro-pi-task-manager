import 'package:intl/intl.dart';

extension NullableDateTimeExtensions on DateTime? {
  /// Formats the nullable DateTime using [pattern]. Returns empty string if null.
  String formatToFullDate({String pattern = 'EEE MMM dd yyyy'}) {
    if (this == null) return '';
    final formatter = DateFormat(pattern);
    return formatter.format(this!);
  }
}

extension NullableStringDateExtensions on String? {
  /// Parses the nullable String into DateTime and formats it using [pattern].
  /// Returns empty string if input is null/empty or parsing fails.
  String formatToFullDate({String pattern = 'EEE MMM dd yyyy'}) {
    if (this == null || this!.isEmpty) return '';
    final parsed = DateTime.tryParse(this!);
    return parsed.formatToFullDate(pattern: pattern);
  }
}
