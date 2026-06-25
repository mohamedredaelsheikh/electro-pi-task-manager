extension FullImagePathGenerator on String? {
  String toFullImagePath() {
    if (this == null || this!.isEmpty) return '';
    if (this!.startsWith('http://') || this!.startsWith('https://')) {
      return this!;
    }
    return this!;
  }
}
