/// Extension on Iterable to provide firstWhereOrNull functionality
/// Returns the first element matching the predicate, or null if none found
extension IterableExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies the given [test], or null if none found.
  ///
  /// This is a null-safe alternative to [firstWhere] with orElse that returns null
  /// instead of throwing an exception when no element is found.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final firstEven = numbers.firstWhereOrNull((n) => n % 2 == 0); // Returns 2
  /// final firstNegative = numbers.firstWhereOrNull((n) => n < 0); // Returns null
  /// ```
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
