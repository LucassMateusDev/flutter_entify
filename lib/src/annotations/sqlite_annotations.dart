class Entity {
  final String tableName;
  final List<Column> columns;

  const Entity(this.tableName, [this.columns = const <Column>[]]);
}

class Column {
  final String? columnName;
  final bool isPrimaryKey;
  final bool isNullable;
  final bool isAutoIncrement;

  const Column({
    this.columnName,
    this.isPrimaryKey = false,
    this.isNullable = true,
    this.isAutoIncrement = false,
  });
}

class ForeignKey {
  final String foreignTable;
  final String foreignColumn;

  const ForeignKey(this.foreignTable, this.foreignColumn);
}
