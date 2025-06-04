import 'package:flutter_entify/src/migrations/i_migration.dart';

abstract class CreateMigration implements IMigration {
  @override
  int get version => 1;
}
