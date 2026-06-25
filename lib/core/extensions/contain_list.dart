/// Extension on [String] to provide a method for checking if it contains all elements of a list.
extension ContainList<T> on String {
  /// Checks if the string contains all elements of the provided list.
  ///
  /// [others] is the list of strings to check against.
  /// Returns `true` if the string contains all elements of the list, otherwise `false`.
  bool containsAll(List<String?> others) {
    return others.any((other) =>
        (other == null) ? false : other.contains(this) || contains(other));
  }
}
