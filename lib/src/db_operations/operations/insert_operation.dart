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
      // final db = await connection.open();
      final values = dbEntity.toUpdateOrInsert(entity);

      final transaction = connection.getTransaction;
      await transaction.open();
      final sql =
          'INSERT INTO ${dbEntity.name} (${values.keys.join(', ')}) VALUES (${values.values.map((e) => "'$e'").join(', ')})';
      transaction.execute(sql);

      // final id = await db.insert(
      //   dbEntity.name,
      //   values,
      //   conflictAlgorithm: ConflictAlgorithm.rollback,
      // );

      for (final relation in dbEntity.relations) {
        final values = relation.mapRelation(entity);

        for (final value in values) {
          final sql =
              'INSERT INTO ${relation.name} (${value.keys.join(', ')}) VALUES (${value.values.map((e) => "'$e'").join(', ')})';
          transaction.execute(sql);
        }
      }

      final result = await transaction.commit(noResult: false);

      return result.first as int;
    } finally {
      await connection.close();
    }
  }
}
