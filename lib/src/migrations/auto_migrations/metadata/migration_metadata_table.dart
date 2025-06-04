import 'package:flutter_entify/src/migrations/auto_migrations/metadata/migration_metadata.dart';

import 'package:sqflite/sqflite.dart';

class MigrationMetadataTable {
  static String get tableName => 'migration_metadata';

  static String get createTableSql => '''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_name TEXT NOT NULL,
        column_definitions TEXT NOT NULL,
        version INTEGER NOT NULL,
        last_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''';

  static String getColumnDefinitionsFromEntity(String entityName) => '''
      SELECT column_definitions
      FROM $tableName
      WHERE entity_name = '$entityName'
    ''';

  static Future<MigrationMetadata?> fromEntity(
    Database db,
    String entityName,
    int oldVersion,
  ) async {
    final result = await db.query(
      tableName,
      where: 'entity_name = ? and version <= ?',
      whereArgs: [entityName, oldVersion],
      orderBy: 'version DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return MigrationMetadata.fromMap(result.first);
  }

  static Future<void> createIfNotExists(Database db) async {
    await db.execute(createTableSql);
  }

  static Future<void> insert(
    Database db,
    MigrationMetadata metadata,
  ) async {
    await db.insert(tableName, metadata.upSave());
  }

  static Future<void> update(
    Database db,
    MigrationMetadata metadata,
  ) async {
    await db.update(
      tableName,
      metadata.upSave(),
      where: 'entity_name = ?',
      whereArgs: [metadata.entityName],
    );
  }

  static Future<void> onDowngrade(
    Database db,
    int newVersion,
  ) async {
    await db.delete(
      tableName,
      where: 'version > ?',
      whereArgs: [newVersion],
    );
  }
}
