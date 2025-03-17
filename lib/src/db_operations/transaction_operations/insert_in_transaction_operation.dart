import 'package:entify/sqflite_entity_mapper_orm.dart';
import 'package:entify/src/db_operations/interfaces/db_transaction_operation.dart';
import 'package:entify/src/transactions/sqlite_db_transaction.dart';

class InsertInTransactionOperation<T> implements DbTransactionOperation<T> {
  @override
  void call(
    SqliteDbTransaction transaction,
    DbEntity<T> dbEntity,
    T entity,
  ) async {
    final values = dbEntity.toUpdateOrInsert(entity);

    transaction.insert(
      dbEntity.name,
      values,
    );
  }
}
