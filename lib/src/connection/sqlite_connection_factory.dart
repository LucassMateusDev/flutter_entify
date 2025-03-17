// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:entify/src/entities/db_entity_service.dart';
import 'package:entify/src/migrations/auto_migrations/migration_manager.dart';
import 'package:synchronized/synchronized.dart';

import '../migrations/sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static SqliteConnectionFactory? _instance;
  final Lock _lock = Lock();
  Database? _db;
  late final String? name;
  late final int version;
  late final SqliteMigrationFactory migrationFactory;
  late final bool withAutoMigrations;

  SqliteConnectionFactory._({
    Database? db,
    this.name,
    required this.version,
    required this.migrationFactory,
    required this.withAutoMigrations,
  }) : _db = db;

  static SqliteConnectionFactory get i {
    if (_instance == null) {
      throw Exception(
          'SqliteConnectionFactory não foi inicializado. Chame SqliteConnectionFactory.initialize().');
    }
    return _instance!;
  }

  static void initialize({
    required String name,
    required int version,
    required SqliteMigrationFactory migrationFactory,
    required bool withAutoMigrations,
  }) {
    _instance ??= SqliteConnectionFactory._(
      migrationFactory: migrationFactory,
      name: name,
      version: version,
      withAutoMigrations: withAutoMigrations,
    );
  }

  static void initializeWithDatabase({
    required Database dataBase,
    required int version,
    required SqliteMigrationFactory migrationFactory,
    required bool withAutoMigrations,
  }) {
    _instance ??= SqliteConnectionFactory._(
      db: dataBase,
      migrationFactory: migrationFactory,
      version: version,
      withAutoMigrations: withAutoMigrations,
    );
  }

  Future<Database> openConnection() async {
    if (_db == null) {
      var databasePath = await getDatabasesPath();
      var databaseFile = join(databasePath, name);
      debugPrint(databaseFile);

      await _lock.synchronized(() async {
        _db ??= await openDatabase(
          databaseFile,
          version: version,
          onConfigure: _onConfigure,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowgrade,
        );
      });
    }
    return _db!;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    if (withAutoMigrations) {
      final migration = await MigrationManager.getMigrations(
        version,
        DbEntityService.i.entities.values.toList(),
        db,
      );
      migration.execute(batch);
      await batch.commit();
      return;
    }

    final migrations = migrationFactory.migrations;
    for (var migration in migrations) {
      migration.create(batch);
    }
    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();

    if (withAutoMigrations) {
      final migration = await MigrationManager.getMigrations(
        newVersion,
        DbEntityService.i.entities.values.toList(),
        db,
        oldVersion: oldVersion,
      );
      migration.execute(batch);
      await batch.commit();
      return;
    }

    final upgradeMigrations = migrationFactory.getUpgradeMigration(oldVersion);

    for (var migration in upgradeMigrations) {
      migration.update(batch);
    }
    await batch.commit();
  }

  Future<void> _onDowgrade(Database db, int oldVersion, int newVersion) async {
    await MigrationManager.dowgrade(newVersion, db);
  }

  Future<void> closeConnection() async {
    _db = null;
    await _db?.close();
  }
}
