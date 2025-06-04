import 'package:flutter_entify/src/migrations/i_migration.dart';
import 'package:flutter_entify/flutter_entify.dart';

import '../exceptions/entify_exception.dart';

class DbContextOptions {
  String databaseName = "";
  int version = 1;
  bool executeBindsBeforeInitialize = false;
  bool _withAutoMigrations = false;
  List<IMigration> _migrations = [];
  // List<DbEntity> entities = [];
  List<CreateDbEntityMap> mappings = [];

  set withAutoMigrations(bool value) {
    if (value && migrations.isNotEmpty) {
      throw EntifyException(
          "Cannot set withAutoMigrations to true when migrations are already set");
    }

    _withAutoMigrations = value;
  }

  set migrations(List<IMigration> value) {
    if (value.isNotEmpty && _withAutoMigrations) {
      throw EntifyException(
        "Cannot set migrations when withAutoMigrations is already set",
      );
    }

    _migrations = value;
  }

  bool get withAutoMigrations => _withAutoMigrations;
  List<IMigration> get migrations => _migrations;
  bool get hasMigrations => migrations.isNotEmpty;
  // bool get hasEntities => entities.isNotEmpty;
  bool get hasMappings => mappings.isNotEmpty;
  bool get executeBindsAfterInitialize => !executeBindsBeforeInitialize;
}
