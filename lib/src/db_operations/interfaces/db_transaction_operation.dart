import 'dart:async';

import 'package:entify/entify.dart';
import 'package:entify/src/transactions/sqlite_db_transaction.dart';

abstract interface class DbTransactionOperation<E> {
  FutureOr<void> call(
    SqliteDbTransaction transaction,
    DbEntity<E> dbEntity,
    E entity,
  );
}
