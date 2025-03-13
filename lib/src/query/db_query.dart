import 'package:sqflite_entity_mapper_orm/src/connection/sqlite_db_connection.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity.dart';
import 'package:sqflite_entity_mapper_orm/src/query/db_entity_query_builder.dart';

class DbQuery<T> {
  final DbEntity<T> dbEntity;
  final SqliteDbConnection connection;

  DbQuery(this.dbEntity, this.connection);

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
