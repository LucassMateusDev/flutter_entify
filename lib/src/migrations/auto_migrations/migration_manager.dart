import 'package:meta/meta.dart';
import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity_definition.dart';
import 'package:sqflite_entity_mapper_orm/src/migrations/auto_migrations/metadata/migration_metadata.dart';
import 'package:sqflite_entity_mapper_orm/src/migrations/auto_migrations/metadata/migration_metadata_table.dart';
import 'package:sqflite_entity_mapper_orm/src/migrations/auto_migrations/migration_operations.dart';

@experimental
class MigrationManager {
  static Future<void> applyMigrations(
    SqliteDbConnection connection,
    List<DbEntity> entities,
  ) async {
    try {
      final db = await connection.open();

      await MigrationMetadataTable.createIfNotExists(connection);

      for (final entity in entities) {
        final currentDefinition = DbEntityDefinition.fromDbEntity(entity);
        final existingMetadata = await MigrationMetadataTable.fromEntity(
          connection,
          entity.name,
        );

        if (existingMetadata == null) {
          final sql = MigrationOperations.generateCreateTableSql(
            entity.name,
            entity.columns,
          );
          // debugPrint(sql);
          await db.execute(sql);

          await MigrationMetadataTable.insert(
            connection,
            MigrationMetadata.fromDbEntityDefinition(currentDefinition),
          );
        } else if (existingMetadata.toDbEntityDefinition() !=
            currentDefinition) {
          final migrationSql = MigrationOperations.generateMigrationSql(
            existingMetadata.toDbEntityDefinition(),
            currentDefinition,
          );

          for (final sql in migrationSql) {
            // debugPrint(sql);
            await db.execute(sql);
          }
          await MigrationMetadataTable.update(
            connection,
            MigrationMetadata.fromDbEntityDefinition(currentDefinition),
          );
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      await connection.close();
    }
  }
}
