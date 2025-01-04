import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/migrations/auto_migrations/metadata/migration_metadata.dart';

class MigrationMetadataTable {
  static String get tableName => 'migration_metadata';

  static String get createTableSql => '''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_name TEXT NOT NULL,
        column_definitions TEXT NOT NULL,
        last_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''';

  static String getColumnDefinitionsFromEntity(String entityName) => '''
      SELECT column_definitions
      FROM $tableName
      WHERE entity_name = '$entityName'
    ''';

  static Future<MigrationMetadata?> fromEntity(
    SqliteDbConnection connection,
    String entityName,
  ) async {
    final db = await connection.open();

    final result = await db.query(
      tableName,
      where: 'entity_name = ?',
      whereArgs: [entityName],
    );

    if (result.isEmpty) return null;

    return MigrationMetadata.fromMap(result.first);
  }

  static Future<void> createIfNotExists(SqliteDbConnection connection) async {
    final db = await connection.open();

    await db.execute(createTableSql);
  }

  static Future<void> insert(
    SqliteDbConnection connection,
    MigrationMetadata metadata,
  ) async {
    final db = await connection.open();

    await db.insert(tableName, metadata.upSave());
  }

  static Future<void> update(
    SqliteDbConnection connection,
    MigrationMetadata metadata,
  ) async {
    final db = await connection.open();

    final id = await db.update(
      tableName,
      metadata.upSave(),
      where: 'entity_name = ?',
      whereArgs: [metadata.entityName],
    );

    if (id == 0) {
      throw Exception('Failed to update metadata');
    }
  }
}
