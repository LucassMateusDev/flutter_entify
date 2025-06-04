import 'package:flutter/foundation.dart';
import 'package:entify/entify.dart';
import 'package:entify/src/entities/db_entity_definition.dart';
import 'package:entify/src/migrations/auto_migrations/metadata/migration_metadata_table.dart';

class MigrationOperations {
  //TODO: Implementar a remoção/alteração de colunas
  //TODO: Implementar a criação/remoção de indexes
  //TODO: Implementar gerenciamento de foreign keys

  static String generateCreateTableSql(
    String tableName,
    List<DbEntityColumn> columns,
  ) {
    final sqlColumns = columns.map((c) => getColumnDefinition(c)).join(', ');
    final foreignKeys = <String>[];

    for (final column in columns) {
      if (column.hasForeignKey) {
        for (var fk in column.foreignKeys) {
          foreignKeys.add(
            'FOREIGN KEY (${column.name}) REFERENCES ${fk.referencedEntity}(${fk.referencedColumn}) ON DELETE ${fk.onDeleteAction.toText}',
          );
        }
      }
    }

    final allDefinitions = [
      sqlColumns,
      ...foreignKeys,
    ].join(', ');

    return 'CREATE TABLE IF NOT EXISTS $tableName ($allDefinitions);';
  }

  static List<String> generateMigrationSql(
    DbEntityDefinition oldDefinition,
    DbEntityDefinition newDefinition,
  ) {
    final sql = <String>[];
    final tableName = newDefinition.tableName;
    final oldColumns = oldDefinition.columns;
    final newColumns = newDefinition.columns;

    if (mustRecrateTable(oldColumns, newColumns)) {
      sql.add('ALTER TABLE $tableName RENAME TO ${tableName}_old;');
      sql.add(generateCreateTableSql(tableName, newColumns));

      final newColumnsToCopy = <DbEntityColumn, DbEntityColumn>{};

      for (var i = 0; i < newColumns.length; i++) {
        final newColumn = newColumns[i];
        if (oldColumns.length == newColumns.length) {
          final oldColumn = oldColumns[i];

          if (oldColumn.isOnlyNameChanged(newColumn)) {
            newColumnsToCopy[newColumn] = oldColumn;
            continue;
          }
          if (oldColumn.isOnlyFKsChanged(newColumn)) {
            newColumnsToCopy[newColumn] = oldColumn;
            continue;
          }
        }

        oldColumns
            .where((oldColumn) => oldColumn == newColumn)
            .forEach((oldColumn) => newColumnsToCopy[newColumn] = oldColumn);
      }

      final newcolumnsToInsert = newColumnsToCopy //
          .keys
          .toList()
          .map((e) => e.name)
          .join(', ');

      final oldColumnsToSelect = newColumnsToCopy //
          .values
          .toList()
          .map((e) => e.name)
          .join(', ');

      sql.add('''
             INSERT INTO $tableName ($newcolumnsToInsert) 
             SELECT $oldColumnsToSelect FROM ${tableName}_old;
             ''');

      sql.add('DROP TABLE ${tableName}_old;');

      return sql;
    }

    final columnsToAdd = <DbEntityColumn>[];

    for (final newColumn in newColumns) {
      if (!oldColumns.contains(newColumn)) {
        columnsToAdd.add(newColumn);
      }
    }

    sql.addAll(addColumnsTableSql(tableName, columnsToAdd));
    sql.addAll(addForeignKeysToTableSql(tableName, columnsToAdd));

    return sql;
  }

  static Future<void> clearMigrations(SqliteDbConnection connection) async {
    final db = await connection.open();
    await db.delete(MigrationMetadataTable.tableName);
  }

  static Future<void> dropAllTables(SqliteDbConnection connection) async {
    final db = await connection.open();
    final tables = <String>[];
    final result = await db.rawQuery(
      "SELECT * FROM sqlite_master WHERE type='table';",
    );

    result.map((e) => e['name']).forEach((e) {
      if (e != 'android_metadata' && e != 'sqlite_sequence') {
        tables.add(e as String);
      }
    });

    for (final tableName in tables) {
      await db.execute('DROP TABLE IF EXISTS $tableName;');
    }
  }

  static List<String> addColumnsTableSql(
    String tableName,
    List<DbEntityColumn> columns,
  ) {
    final sql = columns.map((c) {
      var alterTableSql = 'ALTER TABLE $tableName ADD COLUMN';
      final definition = getColumnDefinition(c);
      return '$alterTableSql $definition;';
    }).toList();

    return sql;
  }

  static List<String> addForeignKeysToTableSql(
    String tableName,
    List<DbEntityColumn> columns,
  ) {
    final sql = <String>[];

    for (final column in columns) {
      if (column.hasForeignKey) {
        for (var fk in column.foreignKeys) {
          sql.add(
            '''ALTER TABLE $tableName 
              ADD CONSTRAINT fk_${column.name}_${fk.referencedEntity} 
              FOREIGN KEY (${column.name}) 
              REFERENCES ${fk.referencedEntity}(${fk.referencedColumn})
              ON DELETE ${fk.onDeleteAction.toText};''',
          );
        }
      }
    }

    return sql;
  }

  static String getColumnDefinition(DbEntityColumn column) {
    var definition = '${column.name} ${column.type.toText}';

    if (column.isPrimaryKey) definition += ' PRIMARY KEY';
    if (!column.isNullable && !column.isPrimaryKey) {
      definition += ' NOT NULL';
    }
    if (column.isAutoIncrement) definition += ' AUTOINCREMENT';
    if (column.defaultValue != null) {
      if (column.type == ColumnType.text) {
        definition += " DEFAULT '${column.defaultValue}'";
      } else {
        definition += ' DEFAULT ${column.defaultValue}';
      }
    }

    return definition;
  }

  static bool mustRecrateTable(
    List<DbEntityColumn> oldColumns,
    List<DbEntityColumn> newColumns,
  ) {
    if (newColumns.length < oldColumns.length) return true;

    if (newColumns.length > oldColumns.length) {
      final newColumnsQuantity = newColumns.length - oldColumns.length;
      var columnsChanges = 0;

      for (final newColumn in newColumns) {
        if (!oldColumns.contains(newColumn)) {
          columnsChanges++;
        }
      }

      return columnsChanges > newColumnsQuantity;
    }

    return !(listEquals(newColumns, oldColumns));
  }

  static bool canCopyColumnValues(
    DbEntityColumn oldColumn,
    DbEntityColumn newColumn, {
    StringBuffer? reason,
  }) {
    //TODO: Ajustar o Metodo
    if (oldColumn.name != newColumn.name) {
      return false;
    }

    // Permitir cópia se o tipo da coluna não mudou.
    if (oldColumn.type == newColumn.type) {
      if (!oldColumn.isNullable && newColumn.isNullable) {
        // Mudança de NOT NULL para NULL é permitida.
        return true;
      }

      if (oldColumn.isNullable && !newColumn.isNullable) {
        // Mudança de NULL para NOT NULL não é permitida se valores nulos existirem.
        reason?.write(
          "Cannot copy values because the column changed from NULLABLE to NOT NULLABLE.",
        );
        return false;
      }

      return true; // Mesmo tipo e compatibilidade garantida.
    }

    // Compatibilidade entre tipos para casos comuns.
    if ((oldColumn.type == ColumnType.integer &&
            newColumn.type == ColumnType.text) ||
        (oldColumn.type == ColumnType.integer &&
            newColumn.type == ColumnType.real)) {
      return true;
    }

    reason?.write(
      "Column types are incompatible: '${oldColumn.type.toText}' to '${newColumn.type.toText}'.",
    );
    return false;
  }
}
