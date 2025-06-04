// ignore: depend_on_referenced_packages
import 'package:flutter_entify/src/transactions/sqlite_db_transaction.dart';

class TransactionService {
  final SqliteDbTransaction _dbTransaction = SqliteDbTransaction();

  static TransactionService? _instance;

  TransactionService._();

  static TransactionService get i {
    _instance ??= TransactionService._();

    return _instance!;
  }

  bool get inTransaction => _dbTransaction.isOpen;

  SqliteDbTransaction get transaction => _dbTransaction;
}
