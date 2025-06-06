import 'package:flutter_entify/flutter_entify.dart';
import 'package:flutter_entify/src/query/sqlite_query_result.dart';

mixin SqliteDbEntityQueryBuilderOperations<T> {
  String get sqlStatement;
  List<dynamic> get parameters;
  SqliteDbConnection get connection;
  DbEntity<T> get dbEntity;

  Future<SqliteQueryResult<T>> execute() async {
    final db = await connection.open();
    try {
      final result = await db.rawQuery(sqlStatement, parameters);

      return SqliteQueryResult<T>(dbEntity, result);
    } finally {
      await connection.close();
    }
  }
}
