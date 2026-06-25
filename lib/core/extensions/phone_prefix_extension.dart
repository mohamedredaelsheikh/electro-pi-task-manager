/// Extension on String for phone prefix operations
extension PhonePrefixExtension on String {
  /// Normalize phone prefix by removing '+', spaces, and dashes
  /// Examples:
  /// - '+20' → '20'
  String normalizePhonePrefix() {
    return replaceAll('+', '').replaceAll('-', '').replaceAll(' ', '').trim();
  }

  /// Add '+' prefix if not present
  /// Examples:
  /// - '20' → '+20'
  String withPlusPrefix() {
    if (isEmpty) return '';
    final normalized = normalizePhonePrefix();
    return normalized.isEmpty ? '' : '+$normalized';
  }

  /// Check if string is a valid phone prefix format
  ///
  /// A valid prefix contains only digits after normalization
  bool isValidPhonePrefix() {
    final normalized = normalizePhonePrefix();
    if (normalized.isEmpty) return false;
    return RegExp(r'^\d+$').hasMatch(normalized);
  }
}

/// Extension on nullable String for phone prefix operations
extension NullablePhonePrefixExtension on String? {
  /// Normalize phone prefix, returns empty string if null
  /// Examples:
  /// - null → ''
  /// - '+20' → '20'
  String normalizePhonePrefix() {
    if (this == null || this!.isEmpty) return '';
    return this!.normalizePhonePrefix();
  }

  /// Add '+' prefix, returns empty string if null
  /// Examples:
  /// - null → ''
  /// - '20' → '+20'
  String withPlusPrefix() {
    if (this == null || this!.isEmpty) return '';
    return this!.withPlusPrefix();
  }

  /// Check if valid prefix, returns false if null
  bool isValidPhonePrefix() {
    if (this == null) return false;
    return this!.isValidPhonePrefix();
  }
}
