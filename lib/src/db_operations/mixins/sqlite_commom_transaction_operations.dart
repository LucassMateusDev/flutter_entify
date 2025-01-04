import 'package:flutter/material.dart';
import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/mixins/sqlite_entity_operations.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/transaction_operations/delete_in_transaction_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/transaction_operations/insert_in_transaction_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/transaction_operations/update_in_transaction_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/transactions/sqlite_db_transaction.dart';

class SqliteCommomTransactionOperations<T> with SqliteEntityOperations<T> {
  SqliteCommomTransactionOperations(
    this.transaction,
    this.dbEntity,
  );

  @protected
  final SqliteDbTransaction transaction;

  @protected
  @override
  final DbEntity<T> dbEntity;

  @override
  SqliteDbConnection get connection => SqliteDbConnection.get();

  @protected
  final deleteOperation = DeleteInTransactionOperation<T>();

  @protected
  final insertOperation = InsertInTransactionOperation<T>();

  @protected
  final updateOperation = UpdateInTransactionOperation<T>();

  void delete(T entity) => deleteOperation(transaction, dbEntity, entity);

  void insert(T entity) => insertOperation(transaction, dbEntity, entity);

  void update(T entity) => updateOperation(transaction, dbEntity, entity);

  Future<void> merge(List<T> entities) async {
    for (final entity in entities) {
      if (await exists(entity)) {
        update(entity);
      } else {
        insert(entity);
      }
    }
  }
}
