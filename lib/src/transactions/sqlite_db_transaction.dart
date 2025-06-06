// ignore: depend_on_referenced_packages
import 'package:flutter_entify/flutter_entify.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_entify/src/exceptions/entify_exception.dart';

import 'package:flutter_entify/src/transactions/transaction_operations.dart';

class SqliteDbTransaction implements TransactionOperations {
  Batch? _batch;

  bool get isOpen => _batch != null;

  void _checkOpenTransaction() {
    if (!isOpen) throw EntifyException('No open transaction');
  }

  Future<List<Object?>> commit({
    bool? exclusive,
    bool? noResult,
    bool? continueOnError,
  }) async {
    _checkOpenTransaction();

    final results = await _batch!.commit(
      exclusive: exclusive,
      noResult: noResult,
      continueOnError: continueOnError,
    );

    close();

    return results;
  }

  Future<void> open() async {
    if (isOpen) throw EntifyException('Transaction already open');

    final batch = await SqliteDbConnection.get().getBatch;

    _batch = batch;
  }

  void close() {
    _batch = null;
  }

  @override
  void delete(String table, {String? where, List<Object?>? whereArgs}) {
    _checkOpenTransaction();

    _batch!.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  void insert(String table, Map<String, dynamic> values) {
    _checkOpenTransaction();

    _batch!.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  @override
  void upSert(
    String table,
    String where,
    List<Object?> whereArgs,
    Map<String, dynamic> values,
  ) {
    _checkOpenTransaction();

    _batch!.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  void update(String table, Map<String, Object?> values,
      {String? where, List<Object?>? whereArgs}) {
    _checkOpenTransaction();

    _batch!.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  void execute(String sql) {
    _checkOpenTransaction();

    _batch!.execute(sql);
  }
}
