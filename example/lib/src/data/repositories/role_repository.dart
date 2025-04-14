import 'package:entify/entify.dart';
import 'package:example/src/domain/entitites.dart';
import 'package:flutter/foundation.dart';

import '../database/app_db_context.dart';

class RoleRepository extends SqliteGenericRepository<Role> {
  RoleRepository({required this.dbContext}) : super(dbSet: dbContext.roles);

  @protected
  final AppDbContext dbContext;

  Future<List<Role>> getAll() async => super.dbSet.findAll();

  Future<int> insert(Role entity) async =>
      await super.dbSet.insertAsync(entity);

  Future<void> delete(Role entity) async {
    final relatedUsers = await dbContext //
        .userRoles
        .findAll('idRole = ${entity.id}');

    await dbContext.openTransaction();

    for (var userRole in relatedUsers) {
      dbContext.delete(userRole);
    }

    dbContext.delete(entity);
    await dbContext.saveChangesAsync();
  }
}
