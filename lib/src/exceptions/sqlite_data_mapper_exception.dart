class SqliteDataMapperException implements Exception {
  final String message;

  SqliteDataMapperException(this.message);

  @override
  String toString() {
    return 'SqliteDataMapperException: $message';
  }
}
