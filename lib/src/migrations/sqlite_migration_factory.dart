import 'i_migration.dart';

class SqliteMigrationFactory {
  final List<IMigration> migrations;
  static SqliteMigrationFactory? _instance;

  static SqliteMigrationFactory get i {
    if (_instance == null) {
      throw Exception(
          'SqliteMigrationFactory não foi inicializado. Chame SqliteMigrationFactory.initialize().');
    }
    return _instance!;
  }

  SqliteMigrationFactory._({required this.migrations});

  static void initialize({required List<IMigration> migrations}) {
    _instance ??= SqliteMigrationFactory._(migrations: migrations);
  }

  List<IMigration> getUpgradeMigration(int version) {
    final upgradeMigrations = migrations.sublist(version);

    return upgradeMigrations;
  }
}
