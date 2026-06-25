extension LastValidDecimal on num {
  String get lastValid {
    // If it's an integer (no fractional part)
    if (this % 1 == 0) {
      return toInt().toString();
    }
    // Always keep 2 decimal digits
    return toStringAsFixed(2);
  }
}
