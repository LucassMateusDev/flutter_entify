import '../mappers/sqlite_db_mapper.dart';

extension SqliteDbMapperExtension on SqliteDbMapper {
  bool tableExists(String tableName) {
    List<String> tables = [];

    for (var entity in entities) {
      tables.add(entity.tableName);
    }

    return tables.contains(tableName);
  }
}
