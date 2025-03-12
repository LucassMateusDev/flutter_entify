import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

abstract class DbContext {
  // final DbEntityService dbEntityService;
  // final SqliteDbConnection dbConnection;
  late final DbEntityService dbEntityService;
  late final SqliteDbConnection dbConnection;
  late final DbContextOptions options;

  DbContext() {
    onConfiguring(DbContextOptionsBuilder());
  }

  List<DbSet> get dbSets;
  List<DbEntity> dbEntities = [];
  List<DbEntityMapper> dbMappings = [];

  // List<DbEntity> get entities => dbSets.map((e) => e.dbEntity).toList();
  List<DbEntity> get entities => dbEntityService.entities.values.toList();

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

  void registerEntities() {
    for (final entity in dbEntities) {
      entity.register();
    }
  }

  void createMappings() {
    for (final dbMapper in dbMappings) {
      dbMapper.create();
    }
  }

  Future<void> _optionsHandler() async {
    if (options.hasEntities) _setDbEntitiesFromOptions();
    if (options.hasMappings) _setDbMappingsFromOptions();
    if (options.withAutoMigrations) {
      await MigrationManager.applyMigrations(dbConnection, entities);
    }
    if (options.executeBindsBeforeInitialize) await binds();
  }

  void _setDbEntitiesFromOptions() {
    dbEntities = options.entities;
    registerEntities();
  }

  void _setDbMappingsFromOptions() {
    dbMappings = options.mappings;
    createMappings();
  }

  Future<void> _executeBindsIfNotExecutedBefore() async {
    if (options.executeBindsAfterInitialize) await binds();
  }
}
