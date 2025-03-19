import 'dart:async';

import 'package:entify/entify.dart';
import 'package:example/data/database/db_entities.dart';
import 'package:example/domain/entitites.dart';

class AppDbContext extends DbContext with DbTransactionOperations {
  final users = DbSet<User>();
  final roles = DbSet<Role>();
  final userRoles = DbSet<UserRoles>();

  @override
  List<DbSet> get dbSets => [users, roles, userRoles];

  @override
  FutureOr<void> binds() async {
    // Configurações adicionais que você deseja executar
    return super.binds();
  }

  @override
  void onConfiguring(DbContextOptionsBuilder optionsBuilder) {
    optionsBuilder
        .databaseName('example2.db')
        .version(4)
        .withAutoMigrations()
        .entities(DbEntitites.get())
        // Se você precisa executar algum bind antes de inicializar os dbSets
        .executeBindsBeforeInitialize();
    // .migrations([MigrationV1()]);
    super.onConfiguring(optionsBuilder);
  }
}
