import 'package:flutter_entify/flutter_entify.dart';
import 'package:flutter_entify/src/db_operations/interfaces/db_transaction_operation.dart';
import 'package:flutter_entify/src/transactions/sqlite_db_transaction.dart';

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
