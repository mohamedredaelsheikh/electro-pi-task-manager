import 'package:intl/intl.dart';

extension TimeAgoExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 5) return 'Just now';
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day) {
      return 'Yesterday';
    }

    return DateFormat('dd MMM yyyy').format(this);
  }
}
