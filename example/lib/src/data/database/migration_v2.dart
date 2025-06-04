import 'package:entify/entify.dart';

class MigrationV2 extends UpdateMigration {
  @override
  int get version => 2;

  @override
  void execute(BatchSchemaExecutor executor) {
    executor.execute('''
      CREATE TABLE Roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
    executor.execute('''
      CREATE TABLE UserRoles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        roleId INTEGER NOT NULL,
        UNIQUE (userId, roleId),
        FOREIGN KEY (userId) REFERENCES Users(id),
        FOREIGN KEY (roleId) REFERENCES Roles(id)
      );
    ''');
  }
}
