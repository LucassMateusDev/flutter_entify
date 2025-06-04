import 'package:meta/meta.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter_entify/flutter_entify.dart';
import 'package:flutter_entify/src/entities/db_entity_definition.dart';
import 'package:flutter_entify/src/migrations/auto_migrations/metadata/migration_metadata.dart';
import 'package:flutter_entify/src/migrations/auto_migrations/metadata/migration_metadata_table.dart';
import 'package:flutter_entify/src/migrations/auto_migrations/migration_operations.dart';

class SqliteAutoMigrationGen {
  final int version;
  final List<String> statements = [];

  SqliteAutoMigrationGen({required this.version});

  void execute(Batch batch) {
    for (final sql in statements) {
      batch.execute(sql);
    }
  }

  void addStatement(String sql) {
    statements.add(sql);
  }
}

@experimental
class MigrationManager {
  static Future<SqliteAutoMigrationGen> getMigrations(
      int version, List<DbEntity> entities, Database db,
      {int? oldVersion}) async {
    final migration = SqliteAutoMigrationGen(version: version);
    try {
      // migration.addStatement(MigrationMetadataTable.createTableSql);
      await MigrationMetadataTable.createIfNotExists(db);

      for (final entity in entities) {
        final currentDefinition = DbEntityDefinition.fromDbEntity(entity);
        final existingMetadata = oldVersion == null
            ? null
            : await MigrationMetadataTable.fromEntity(
                db,
                entity.name,
                oldVersion,
              );

        if (existingMetadata == null) {
          final sql = MigrationOperations.generateCreateTableSql(
            entity.name,
            entity.columns,
          );
          // debugPrint(sql);
          migration.addStatement(sql);

          await MigrationMetadataTable.insert(
            db,
            MigrationMetadata.fromDbEntityDefinition(
              currentDefinition,
              version,
            ),
          );
        } else if (existingMetadata.toDbEntityDefinition() !=
            currentDefinition) {
          final migrationSql = MigrationOperations.generateMigrationSql(
            existingMetadata.toDbEntityDefinition(),
            currentDefinition,
          );

          for (final sql in migrationSql) {
            // debugPrint(sql);
            migration.addStatement(sql);
          }
          await MigrationMetadataTable.insert(
            db,
            MigrationMetadata.fromDbEntityDefinition(
              currentDefinition,
              version,
            ),
          );
        }
      }
      return migration;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> dowgrade(
    int version,
    Database db,
  ) async {
    await MigrationMetadataTable.onDowngrade(db, version);
  }
}
