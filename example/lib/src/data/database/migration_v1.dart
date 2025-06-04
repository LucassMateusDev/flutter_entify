import 'package:flutter_entify/flutter_entify.dart';

class MigrationV1 extends CreateMigration {
  @override
  void execute(BatchSchemaExecutor executor) {
    executor.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
  }
}
