import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/interfaces/db_transaction_operation.dart';
import 'package:sqflite_entity_mapper_orm/src/transactions/sqlite_db_transaction.dart';

class DeleteInTransactionOperation<T> implements DbTransactionOperation<T> {
  @override
  void call(
    SqliteDbTransaction transaction,
    DbEntity<T> dbEntity,
    T entity,
  ) async {
    final primaryKey = dbEntity.primaryKey(entity);
    final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
    final args = primaryKey.values.toList();

    transaction.delete(
      dbEntity.name,
      where: clause,
      whereArgs: args,
    );
  }
}
