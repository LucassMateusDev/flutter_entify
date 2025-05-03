import 'package:entify/entify.dart';
import 'package:entify/src/db_operations/interfaces/db_operation.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

class InsertOperation<T> implements DbOperation<T, int> {
  @override
  Future<int> call(
    SqliteDbConnection connection,
    DbEntity<T> dbEntity,
    T entity,
  ) async {
    try {
      final db = await connection.open();
      final values = dbEntity.toUpdateOrInsert(entity);

      final id = await db.insert(
        dbEntity.name,
        values,
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );

      return id;
    } finally {
      await connection.close();
    }
  }
}
