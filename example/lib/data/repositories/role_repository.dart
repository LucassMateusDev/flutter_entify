import 'package:entify/entify.dart';
import 'package:example/domain/entitites.dart';

import '../database/app_db_context.dart';

class RoleRepository extends SqliteGenericRepository<Role> {
  RoleRepository({required AppDbContext dbContext})
      : super(dbSet: dbContext.roles);

  Future<List<Role>> getAll() async => super.dbSet.findAll();
}
