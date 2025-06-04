import 'dart:async';

import 'package:flutter_entify/flutter_entify.dart';
import 'package:flutter_entify/src/transactions/sqlite_db_transaction.dart';

abstract interface class DbTransactionOperation<E> {
  FutureOr<void> call(
    SqliteDbTransaction transaction,
    DbEntity<E> dbEntity,
    E entity,
  );
}
