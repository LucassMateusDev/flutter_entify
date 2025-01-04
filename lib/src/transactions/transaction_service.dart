// ignore: depend_on_referenced_packages
import 'package:sqflite_entity_mapper_orm/src/transactions/sqlite_db_transaction.dart';

class TransactionService {
  late final SqliteDbTransaction _dbTransaction;

  static TransactionService? _instance;

  TransactionService._() {
    _dbTransaction = SqliteDbTransaction();
  }

  static TransactionService get i {
    _instance ??= TransactionService._();

    return _instance!;
  }

  bool get inTransaction => _dbTransaction.isOpen;

  SqliteDbTransaction get transaction => _dbTransaction;
}
