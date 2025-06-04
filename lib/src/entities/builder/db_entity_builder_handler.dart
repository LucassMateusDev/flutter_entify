import 'package:flutter_entify/src/entities/db_entity_columns.dart';

class DbEntityBuilderHandler<T> {
  static String getTableName<T>([String? name]) {
    if (name == null || name.isEmpty) return T.toString();
    return name;
  }

  static List<DbEntityColumn> inferColumnsFromDefinition({
    required Map<String, Type> entityDefinition,
    String idField = 'id',
  }) {
    final map = entityDefinition;
    final List<DbEntityColumn> columns = [];

    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == int) {
        columns.add(IntColumn(
          name: key,
          isPrimaryKey: key == idField,
          isAutoIncrement: key == idField,
          isNullable: !(key == idField),
        ));
      } else if (value == double) {
        columns.add(RealColumn(name: key, isNullable: false));
      } else if (value == bool) {
        columns.add(BoolColumn(name: key, isNullable: false));
      } else {
        columns.add(TextColumn(name: key, isNullable: true));
      }
    }

    return columns;
  }
}
