extension CapitalizeString on String {
  String capitalize() {
    if (length < 2) {
      return toUpperCase();
    } else {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    }
  }
}
