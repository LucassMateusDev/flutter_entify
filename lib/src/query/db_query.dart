import 'package:entify/src/connection/sqlite_db_connection.dart';
import 'package:entify/src/entities/db_entity.dart';
import 'package:entify/src/query/db_entity_query_builder.dart';

class DbEntityQuery<T> {
  final DbEntity<T> dbEntity;
  final SqliteDbConnection connection;

  DbEntityQuery(this.dbEntity, this.connection);

  DbEntityQueryBuilder<T> select({required List<String> columns}) {
    return DbEntityQueryBuilder<T>(
      dbEntity,
      connection,
      columns,
    );
  }

  DbEntityQueryBuilder<T> selectAll() {
    return DbEntityQueryBuilder<T>(
      dbEntity,
      connection,
      [],
    );
  }
}
