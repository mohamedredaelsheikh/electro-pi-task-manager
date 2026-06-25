extension CapitalFirst on String? {
  String? firstCapital() {
    if (this == null) return null;
    if (this!.isNotEmpty) {
      return "${this![0].toUpperCase()}${this!.substring(1)}";
    }
    return this;
  }

  String? get firstCapitalEachWord {
    return this?.split(" ").map((e) => e.firstCapital()!).join(" ");
  }
}
