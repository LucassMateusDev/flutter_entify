import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/interfaces/db_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/exceptions/sqlite_data_mapper_exception.dart';
// ignore: depend_on_referenced_packages

class SelectOperation<T> implements DbOperation<T, T> {
  @override
  Future<T> call(
    SqliteDbConnection connection,
    DbEntity<T> dbEntity,
    T entity,
  ) async {
    final db = await connection.open();
    try {
      T? result;

      final primaryKey = dbEntity.primaryKey(entity);
      final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
      final args = primaryKey.values.toList();

      final response = await db.query(
        dbEntity.name,
        where: clause,
        whereArgs: args,
      );

      if (response.isEmpty) {
        throw SqliteDataMapperException('Register not found');
      }

      result = dbEntity.mapToEntity(response.first);

      return result!;
    } finally {
      await connection.close();
    }
  }
}
