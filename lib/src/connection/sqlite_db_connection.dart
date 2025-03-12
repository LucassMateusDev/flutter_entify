import '../transactions/sqlite_db_transaction.dart';
import '../transactions/transaction_service.dart';
import 'sqlite_connection_factory.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

class SqliteDbConnection {
  final SqliteConnectionFactory _cnx;
  // bool _inTransaction = false;
  final TransactionService _transactionService = TransactionService.i;

  SqliteDbConnection.get() : _cnx = SqliteConnectionFactory.i;

  bool get hasOpenTransaction => _transactionService.inTransaction;

  Future<Database> open() async => _cnx.openConnection();

  Future<void> close() async => _cnx.closeConnection();

  SqliteDbTransaction get getTransaction => _transactionService.transaction;

  Future<Batch> get getBatch async => (await open()).batch();
}
