import 'package:meta/meta.dart';
import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/operations/delete_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/operations/select_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/operations/insert_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/operations/update_operation.dart';

import '../../exceptions/sqlite_data_mapper_exception.dart';

mixin SqliteOperations<T> {
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

  Future<void> deleteAsync(T entity) async {
    await deleteOperation(connection, dbEntity, entity);
  }

  Future<T?> selectAsync(T entity) async {
    return await selectOperation(connection, dbEntity, entity);
  }

  Future<int> insertAsync(T entity) async {
    final id = await insertOperation(connection, dbEntity, entity);

    if (id == 0) throw SqliteDataMapperException('Error on insert entity');

    return id;
  }

  Future<void> updateAsync(T entity) async {
    await updateOperation(connection, dbEntity, entity);
  }
}
