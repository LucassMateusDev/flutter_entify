import 'package:sqflite_entity_mapper_orm/src/connection/sqlite_db_connection.dart';
import 'package:sqflite_entity_mapper_orm/src/query/query_builder.dart';

mixin QueryMixin {
  SqliteDbConnection get queryConnection;

  QueryBuilder get query => QueryBuilder(queryConnection);
}
