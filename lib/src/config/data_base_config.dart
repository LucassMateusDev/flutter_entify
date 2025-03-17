import 'package:meta/meta.dart';

import '../connection/sqlite_adm_connection.dart';
import '../connection/sqlite_connection_factory.dart';
import '../exceptions/sqlite_data_mapper_exception.dart';
import '../migrations/i_migration.dart';
import '../migrations/sqlite_migration_factory.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

//TODO: Implements Completer to initialize the database
@protected
class DataBaseConfig {
  Database? _db;
  final String? name;
  final int version;
  final List<IMigration> migrations;
  final bool withAutoMigrations;
  static DataBaseConfig? _instance;

  static DataBaseConfig get i {
    if (_instance == null) {
      throw SqliteDataMapperException(
          'DataBaseConfig não foi inicializado. Chame DataBaseConfig.initialize().');
    }
    return _instance!;
  }

  DataBaseConfig._({
    Database? db,
    this.name,
    required this.version,
    required this.migrations,
    required this.withAutoMigrations,
  }) {
    _db = db;
    _onConfiguring();
  }

  void _onConfiguring() {
    SqliteMigrationFactory.initialize(migrations: migrations);

    (_db == null)
        ? SqliteConnectionFactory.initialize(
            name: name!,
            version: version,
            migrationFactory: SqliteMigrationFactory.i,
            withAutoMigrations: withAutoMigrations,
          )
        : SqliteConnectionFactory.initializeWithDatabase(
            dataBase: _db!,
            version: version,
            migrationFactory: SqliteMigrationFactory.i,
            withAutoMigrations: withAutoMigrations,
          );

    SqliteAdmConnection.initialize(SqliteConnectionFactory.i);
  }

  static void initialize({
    Database? dataBase,
    String? name,
    required int version,
    required List<IMigration> migrations,
    bool withAutoMigrations = false,
  }) {
    _instance ??= DataBaseConfig._(
      db: dataBase,
      name: name,
      version: version,
      migrations: migrations,
      withAutoMigrations: withAutoMigrations,
    );
  }
}
