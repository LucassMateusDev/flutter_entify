import 'dart:async';

import 'package:entify/entify.dart';
import 'package:example/src/domain/entitites.dart';

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
        // Se você precisa executar algum bind antes de inicializar os dbSets
        .executeBindsBeforeInitialize();
    // .migrations([MigrationV1()]);
    super.onConfiguring(optionsBuilder);
  }

  @override
  List<DbEntity> configureEntites(DbEntityBuilderProvider provider) => [
        provider
            .getSimpleEntityBuilder<Role>()
            .entityDefinition({
              'id': int,
              'name': String,
              'description': String,
            })
            .mapToEntity((map) => Role(
                  id: map['id'] as int?,
                  name: map['name'] as String,
                  description: map['description'] ?? '',
                ))
            .toUpdateOrInsert((e) => {
                  'name': e.name,
                  'description': e.description,
                })
            .build(),
        provider
            .getDefaultDbEntityBuilder<User>()
            .primaryKey((e) => {'id': e.id})
            .mapToEntity((map) => User(
                  id: map['id'] as int?,
                  name: map['name'] as String,
                  email: map['email'] ?? '',
                  roles: [],
                ))
            .toUpdateOrInsert((e) => {'name': e.name, 'email': e.email})
            .columns(
          [
            IntColumn(
              name: 'id',
              isPrimaryKey: true,
              isNullable: false,
              isAutoIncrement: true,
            ),
            TextColumn(name: 'name', isNullable: false),
            TextColumn(name: 'email'),
          ],
        ).build(),
        provider
            .getDefaultDbEntityBuilder<UserRoles>()
            .primaryKey((e) => {'id': e.id})
            .uniqueKeys(
              (e) => [
                {'idRole': e.idRole, 'idUser': e.idUser},
              ],
            )
            .mapToEntity(
              (map) => UserRoles(
                id: map['id'] as int?,
                idRole: map['idRole'] as int,
                idUser: map['idUser'] as int,
              ),
            )
            .toUpdateOrInsert((e) => {'idRole': e.idRole, 'idUser': e.idUser})
            .columns(
          [
            IntColumn(
              name: 'id',
              isPrimaryKey: true,
              isNullable: false,
              isAutoIncrement: true,
            ),
            IntColumn(name: 'idRole', isNullable: false),
            IntColumn(name: 'idUser', isNullable: false),
          ],
        ).build(),
      ];
}
