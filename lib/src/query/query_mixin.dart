import 'package:entify/src/connection/sqlite_db_connection.dart';
import 'package:entify/src/query/query_builder.dart';

mixin QueryMixin {
  SqliteDbConnection get queryConnection;

  QueryBuilder get query => QueryBuilder(queryConnection);
}
