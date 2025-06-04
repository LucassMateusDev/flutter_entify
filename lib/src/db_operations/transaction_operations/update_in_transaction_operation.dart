import 'package:flutter_entify/flutter_entify.dart';
import 'package:flutter_entify/src/db_operations/interfaces/db_transaction_operation.dart';
import 'package:flutter_entify/src/transactions/sqlite_db_transaction.dart';

class UpdateInTransactionOperation<T> implements DbTransactionOperation<T> {
  @override
  void call(
    SqliteDbTransaction transaction,
    DbEntity<T> dbEntity,
    T entity,
  ) async {
    final primaryKey = dbEntity.primaryKey(entity);
    final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
    final args = primaryKey.values.toList();

    transaction.update(
      dbEntity.name,
      dbEntity.toUpdateOrInsert(entity),
      where: clause,
      whereArgs: args,
    );
  }
}
