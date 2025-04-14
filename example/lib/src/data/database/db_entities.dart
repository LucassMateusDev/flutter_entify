import 'package:entify/entify.dart';
import 'package:example/src/domain/entitites.dart';

class DbEntitites {
  static List<DbEntity> get() {
    return [
      RoleDbEntity().entity,
      UserDbEntity().entity,
      UserRolesDbEntity().entity,
    ];
  }
}

class RoleDbEntity extends DbEntityProvider<Role> {
  @override
  DbEntity<Role> get entity => super
          .builder
          .name('Roles')
          .primaryKey((e) => {'id': e.id})
          .mapToEntity(
            (map) => Role(
              id: map['id'] as int?,
              name: map['name'] as String,
              description: map['description'] ?? '',
            ),
          )
          .toUpdateOrInsert(
            (e) => {'name': e.name, 'description': e.description},
          )
          .columns(
        [
          IntColumn(
            name: 'id',
            isPrimaryKey: true,
            isNullable: false,
            isAutoIncrement: true,
          ),
          TextColumn(name: 'name', isNullable: false),
          TextColumn(name: 'description'),
        ],
      ).build();
}

class UserDbEntity extends DbEntityProvider<User> {
  @override
  DbEntity get entity => super
          .builder
          .name('Users')
          .primaryKey((e) => {'id': e.id})
          .mapToEntity(
            (map) => User(
              id: map['id'] as int?,
              name: map['name'] as String,
              email: map['email'] ?? '',
              roles: [],
            ),
          )
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
      ).build();
}

class UserRolesDbEntity extends DbEntityProvider<UserRoles> {
  @override
  DbEntity get entity => super
          .builder
          .name('UserRoles')
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
      ).build();
}
