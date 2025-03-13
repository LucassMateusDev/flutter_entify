import 'package:meta/meta.dart';
import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/common_operations/delete_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/common_operations/select_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/common_operations/insert_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/common_operations/update_operation.dart';

import '../../exceptions/sqlite_data_mapper_exception.dart';

mixin SqliteCommomOperations<T> {
  SqliteDbConnection get connection;
  DbEntity<T> get dbEntity;

  @protected
  final deleteOperation = DeleteOperation<T>();
  @protected
  final selectOperation = SelectOperation<T>();
  @protected
  final insertOperation = InsertOperation<T>();
  @protected
  final updateOperation = UpdateOperation<T>();

  Future<void> delete(T entity) async {
    await deleteOperation(connection, dbEntity, entity);
  }

  Future<T?> select(T entity) async {
    return await selectOperation(connection, dbEntity, entity);
  }

  Future<int> insert(T entity) async {
    final id = await insertOperation(connection, dbEntity, entity);

    if (id == 0) throw SqliteDataMapperException('Erro ao inserir registro');

    return id;
  }

  Future<void> update(T entity) async {
    await updateOperation(connection, dbEntity, entity);
  }
}
