import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/query/sqlite_query_result.dart';

mixin SqliteDbEntityQueryBuilderOperations<T> {
  String get sqlStatement;
  SqliteDbConnection get connection;
  DbEntity<T> get dbEntity;

  Future<SqliteQueryResult<T>> execute() async {
    final db = await connection.open();
    try {
      final result = await db.rawQuery(sqlStatement);

      return SqliteQueryResult<T>(dbEntity, result);
    } finally {
      await connection.close();
    }
  }
}
