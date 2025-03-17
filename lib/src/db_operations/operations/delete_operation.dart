import 'package:entify/sqflite_entity_mapper_orm.dart';
import 'package:entify/src/db_operations/interfaces/db_operation.dart';

class DeleteOperation<T> implements DbOperation<T, void> {
  @override
  Future<void> call(
    SqliteDbConnection connection,
    DbEntity<T> dbEntity,
    T entity,
  ) async {
    final db = await connection.open();
    try {
      final primaryKey = dbEntity.primaryKey(entity);
      final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
      final args = primaryKey.values.toList();

      await db.delete(
        dbEntity.name,
        where: clause,
        whereArgs: args,
      );
    } finally {
      await connection.close();
    }
  }
}
