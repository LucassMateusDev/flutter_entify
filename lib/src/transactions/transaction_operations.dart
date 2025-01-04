abstract interface class TransactionOperations {
  void delete(String table, {String? where, List<Object?>? whereArgs});
  void insert(String table, Map<String, dynamic> values);
  void upSert(
    String table,
    String where,
    List<Object?> whereArgs,
    Map<String, dynamic> values,
  );
  void update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    // ConflictAlgorithm? conflictAlgorithm,
  });
}
