import 'package:example/src/data/database/app_db_context.dart';
import 'package:example/src/domain/entitites.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  UserRepository({required this.dbContext});

  @protected
  final AppDbContext dbContext;

  Future<User?> get(User entity) async {
    final user = await dbContext.users.selectAsync(entity);

    if (user != null) {
      final roles = await dbContext.roles.query
          .selectAll()
          .join('UserRoles ur', onClause: 'x.id = ur.idRole')
          .where('ur.idUser = ${user.id}')
          .execute();

      user.roles.addAll(roles.entities);
    }

    return user;
  }

  Future<List<User>> getAll() async {
    final users = await dbContext.users.findAll();

    for (var user in users) {
      final roles = await dbContext.roles.query
          .selectAll()
          .join('UserRoles ur', onClause: 'x.id = ur.idRole')
          .where('ur.idUser = ${user.id}')
          .execute();

      user.roles.addAll(roles.entities);
    }

    return users;
  }

  Future<int> insert(User entity) async {
    // await dbContext.openTransaction();
    // dbContext.insert(entity);

    // for (var role in entity.roles) {
    //   dbContext.insert(UserRoles(idRole: role.id!, idUser: entity.id!));
    // }

    // final results = await dbContext.saveChangesAsync();
    // return results.first as int;
    return await dbContext.users.insertAsync(entity);
  }

  Future<void> update(User entity) async {
    // final relatedRoles = await dbContext //
    //     .userRoles
    //     .findAll('idUser = ${entity.id}');

    // await dbContext.openTransaction();

    // for (var role in relatedRoles) {
    //   dbContext.delete(role);
    // }

    // dbContext.update(entity);

    // for (var role in entity.roles) {
    //   dbContext.insert(UserRoles(idRole: role.id!, idUser: entity.id!));
    // }

    // await dbContext.saveChangesAsync();
    await dbContext.users.updateAsync(entity);
  }

  Future<void> delete(User entity) async {
    await dbContext.openTransaction();
    dbContext.delete(entity);

    for (var role in entity.roles) {
      dbContext.delete(UserRoles(idRole: role.id!, idUser: entity.id!));
    }

    await dbContext.saveChangesAsync();
  }
}
