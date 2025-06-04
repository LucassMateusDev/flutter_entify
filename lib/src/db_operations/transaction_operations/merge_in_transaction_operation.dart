import 'dart:async';

import 'package:flutter_entify/src/db_operations/interfaces/db_transaction_operation.dart';
import 'package:flutter_entify/src/entities/db_entity.dart';
import 'package:flutter_entify/src/transactions/sqlite_db_transaction.dart';

class MergeInTransactionOperation<T> implements DbTransactionOperation<T> {
  @override
  FutureOr<void> call(
    SqliteDbTransaction transaction,
    DbEntity<T> dbEntity,
    T entity,
  ) {}
}
