import 'dart:async';

import 'package:sqflite_entity_mapper_orm/src/db_operations/interfaces/db_transaction_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity.dart';
import 'package:sqflite_entity_mapper_orm/src/transactions/sqlite_db_transaction.dart';

class MergeInTransactionOperation<T> implements DbTransactionOperation<T> {
  @override
  FutureOr<void> call(
    SqliteDbTransaction transaction,
    DbEntity<T> dbEntity,
    T entity,
  ) {}
}
