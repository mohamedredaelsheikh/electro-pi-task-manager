extension StringToNum on String {
  num? toNum() {
    final parsed = num.tryParse(this);
    return parsed;
  }
}
