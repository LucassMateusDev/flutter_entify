import 'package:entify/entify.dart';
import 'package:sqflite_common/sqlite_api.dart';

class MigrationV1 implements IMigration {
  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE Roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
    batch.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
  }

  @override
  void update(Batch batch) {}
}
