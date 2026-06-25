import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String get formattedShort {
    return DateFormat('E MMM dd yyyy').format(this);
  }
}
