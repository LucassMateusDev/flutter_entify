import 'package:flutter_entify/src/migrations/i_migration.dart';
import 'package:meta/meta.dart';
import 'package:flutter_entify/flutter_entify.dart';

class DbContextOptionsBuilder {
  final DbContextOptions _options = DbContextOptions();

  DbContextOptionsBuilder databaseName(String databaseName) {
    _options.databaseName = databaseName;
    return this;
  }

  DbContextOptionsBuilder version(int version) {
    _options.version = version;
    return this;
  }

  // DbContextOptionsBuilder entities(List<DbEntity> entities) {
  //   _options.entities = entities;
  //   return this;
  // }

  DbContextOptionsBuilder mappings(List<CreateDbEntityMap> mappings) {
    _options.mappings = mappings;
    return this;
  }

  DbContextOptionsBuilder migrations(List<IMigration> migrations) {
    _options.migrations = migrations;
    return this;
  }

  DbContextOptionsBuilder executeBindsBeforeInitialize() {
    _options.executeBindsBeforeInitialize = true;
    return this;
  }

  @experimental
  DbContextOptionsBuilder withAutoMigrations() {
    _options.withAutoMigrations = true;
    return this;
  }

  DbContextOptions build() {
    return _options;
  }
}
