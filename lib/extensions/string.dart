extension StringExtensions on String {
  String toUpperCaseFirst() {
    if (length == 0) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
