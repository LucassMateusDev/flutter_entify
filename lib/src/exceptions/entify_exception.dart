class EntifyException implements Exception {
  final String message;

  EntifyException(this.message);

  @override
  String toString() {
    return 'EntifyException: $message';
  }
}
