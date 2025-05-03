import 'package:entify/entify.dart';
import 'package:entify/src/db_operations/interfaces/db_operation.dart';
import 'package:sqflite/sqflite.dart';

class UpdateOperation<T> implements DbOperation<T, void> {
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

      await db.update(
        dbEntity.name,
        dbEntity.toUpdateOrInsert(entity),
        where: clause,
        whereArgs: args,
      );

      for (final relation in dbEntity.relations) {
        final values = relation.mapRelation(entity);

        for (final value in values) {
          await db.insert(
            relation.name,
            value,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } finally {
      await connection.close();
    }
  }
}
