import 'dart:async';

import 'package:flutter_entify/flutter_entify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_entify/src/config/data_base_config.dart';
import 'package:flutter_entify/src/entities/db_entity_service.dart';
import 'package:flutter_entify/src/transactions/sqlite_db_transaction.dart';

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

  List<DbEntity> configureEntites(DbEntityBuilderProvider provider);

  Future<void> initialize() async {
    DataBaseConfig.initialize(
      name: options.databaseName,
      version: options.version,
      migrations: options.migrations,
      withAutoMigrations: options.withAutoMigrations,
    );
    dbEntityService = DbEntityService.i;
    dbConnection = SqliteDbConnection.get();
    final entities = configureEntites(DbEntityBuilderProvider());
    registerEntities(entities);
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

  void createMappings(List<CreateDbEntityMap> dbMappings) {
    for (final dbMapper in dbMappings) {
      dbMapper.create();
    }
  }

  Future<void> _optionsHandler() async {
    // if (options.hasEntities) _setDbEntitiesFromOptions();
    if (options.hasMappings) _setDbMappingsFromOptions();
    if (options.executeBindsBeforeInitialize) await binds();
  }

  // void _setDbEntitiesFromOptions() {
  // registerEntities(options.entities);
  // }

  void _setDbMappingsFromOptions() {
    createMappings(options.mappings);
  }

  Future<void> _executeBindsIfNotExecutedBefore() async {
    if (options.executeBindsAfterInitialize) await binds();
  }
}
