import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite_entity_mapper_orm/src/config/data_base_config.dart';
import 'package:sqflite_entity_mapper_orm/src/connection/sqlite_db_connection.dart';
import 'package:sqflite_entity_mapper_orm/src/context/db_context_options.dart';
import 'package:sqflite_entity_mapper_orm/src/context/db_context_options_builder.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity_service.dart';
import 'package:sqflite_entity_mapper_orm/src/mappers/db_entity_mapper.dart';
import 'package:sqflite_entity_mapper_orm/src/migrations/auto_migrations/migration_manager.dart';
import 'package:sqflite_entity_mapper_orm/src/set/db_set.dart';
import 'package:sqflite_entity_mapper_orm/src/transactions/sqlite_db_transaction.dart';

abstract class DbContext {
  late final DbContextOptions options;
  late final DbEntityService dbEntityService;
  late final SqliteDbConnection dbConnection;
  @protected
  final SqliteDbTransaction transaction = SqliteDbTransaction();

  DbContext() {
    onConfiguring(DbContextOptionsBuilder());
  }

  List<DbSet> get dbSets;
  List<DbEntity> get dbEntities => dbEntityService.entities.values.toList();

  @mustCallSuper
  FutureOr<void> binds() async {}

  @mustCallSuper
  void onConfiguring(DbContextOptionsBuilder optionsBuilder) {
    options = optionsBuilder.build();
  }

  Future<void> initialize() async {
    DataBaseConfig.initialize(
      name: options.databaseName,
      version: options.version,
      migrations: options.migrations,
    );
    dbEntityService = DbEntityService.i;
    dbConnection = SqliteDbConnection.get();
    await _optionsHandler();
    dbSetsInitialize(dbSets);
    await _executeBindsIfNotExecutedBefore();
  }

  void dbSetsInitialize(List<DbSet> dbSets) {
    for (var set in dbSets) {
      // ignore: invalid_use_of_protected_member
      set.initialize(dbEntityService, dbConnection);
    }
  }

  void registerEntities(List<DbEntity> dbEntities) {
    for (final entity in dbEntities) {
      entity.register();
    }
  }

  void createMappings(List<DbEntityMapper> dbMappings) {
    for (final dbMapper in dbMappings) {
      dbMapper.create();
    }
  }

  Future<void> _optionsHandler() async {
    if (options.hasEntities) _setDbEntitiesFromOptions();
    if (options.hasMappings) _setDbMappingsFromOptions();
    if (options.executeBindsBeforeInitialize) await binds();
    if (options.withAutoMigrations) {
      await MigrationManager.applyMigrations(dbConnection, dbEntities);
    }
  }

  void _setDbEntitiesFromOptions() {
    registerEntities(options.entities);
  }

  void _setDbMappingsFromOptions() {
    createMappings(options.mappings);
  }

  Future<void> _executeBindsIfNotExecutedBefore() async {
    if (options.executeBindsAfterInitialize) await binds();
  }
}
