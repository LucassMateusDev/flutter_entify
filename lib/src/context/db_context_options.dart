import 'package:meta/meta.dart';
import 'package:entify/entify.dart';

import '../exceptions/sqlite_data_mapper_exception.dart';

class DbContextOptions {
  String databaseName = "";
  int version = 1;
  bool executeBindsBeforeInitialize = false;
  bool _withAutoMigrations = false;
  List<IMigration> _migrations = [];
  List<DbEntity> entities = [];
  List<DbEntityMapper> mappings = [];

  @experimental
  set withAutoMigrations(bool value) {
    if (value && migrations.isNotEmpty) {
      throw SqliteDataMapperException(
          "Cannot set withAutoMigrations to true when migrations are already set");
    }

    _withAutoMigrations = value;
  }

  set migrations(List<IMigration> value) {
    if (value.isNotEmpty && _withAutoMigrations) {
      throw SqliteDataMapperException(
        "Cannot set migrations when withAutoMigrations is already set",
      );
    }

    _migrations = value;
  }

  bool get withAutoMigrations => _withAutoMigrations;
  List<IMigration> get migrations => _migrations;
  bool get hasMigrations => migrations.isNotEmpty;
  bool get hasEntities => entities.isNotEmpty;
  bool get hasMappings => mappings.isNotEmpty;
  bool get executeBindsAfterInitialize => !executeBindsBeforeInitialize;
}
