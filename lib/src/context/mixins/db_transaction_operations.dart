import 'package:entify/sqflite_entity_mapper_orm.dart';
import 'package:entify/src/db_operations/transaction_operations/delete_in_transaction_operation.dart';
import 'package:entify/src/db_operations/transaction_operations/insert_in_transaction_operation.dart';
import 'package:entify/src/db_operations/transaction_operations/update_in_transaction_operation.dart';

mixin DbTransactionOperations on DbContext {
  Future<void> openTransaction() async => transaction.open();

  void delete<T>(T entity) {
    final dbEntity = dbEntityService.get<T>();
    final deleteOperation = DeleteInTransactionOperation<T>();

    deleteOperation(transaction, dbEntity, entity);
  }

  void insert<T>(T entity) {
    final dbEntity = dbEntityService.get<T>();
    final insertOperation = InsertInTransactionOperation<T>();

    insertOperation(transaction, dbEntity, entity);
  }

  void update<T>(T entity) {
    final dbEntity = dbEntityService.get<T>();
    final updateOperation = UpdateInTransactionOperation<T>();

    updateOperation(transaction, dbEntity, entity);
  }

  Future<List<Object?>> saveChangesAsync({
    bool? exclusive,
    bool? noResult,
    bool? continueOnError,
  }) async {
    return transaction.commit(
      exclusive: exclusive,
      noResult: noResult,
      continueOnError: continueOnError,
    );
  }
}
