import 'package:flutter/material.dart';
import 'package:flutter_entify/flutter_entify.dart';

class QueryBuilder {
  QueryBuilder(this.connection);

  @protected
  final SqliteDbConnection connection;

  String _sqlStatement = '';
  final List<dynamic> _parameters = [];
  bool _whereAdded = false;
  bool _blockStarted = false;

  String get sqlStatement => _sqlStatement;
  List<dynamic> get parameters => _parameters;

  void clearQuery() {
    _sqlStatement = '';
    _parameters.clear();
    _whereAdded = false;
    _blockStarted = false;
  }

  QueryBuilder select([List<String> columns = const []]) {
    _sqlStatement = 'SELECT ${columns.isEmpty ? 'x.*' : columns.join(', ')}';
    return this;
  }

  QueryBuilder from(String tableName, [String alias = 'x']) {
    _sqlStatement += ' FROM $tableName $alias';
    return this;
  }

  QueryBuilder where(String condition, [dynamic value]) {
    if (!_whereAdded) {
      _sqlStatement += ' WHERE $condition';
      _whereAdded = true;
    } else {
      _sqlStatement += ' AND $condition';
    }
    if (value != null) _parameters.add(value);
    return this;
  }

  QueryBuilder not([String condition = '', dynamic value]) {
    if (!_whereAdded) {
      _sqlStatement += ' WHERE NOT $condition';
      _whereAdded = true;
    } else {
      _sqlStatement += ' NOT $condition';
    }
    if (value != null) _parameters.add(value);
    return this;
  }

  QueryBuilder equals(String column, dynamic value) {
    return where('$column = ?', value);
  }

  QueryBuilder notEquals(String column, dynamic value) {
    return where('$column <> ?', value);
  }

  QueryBuilder inValues(String column, List<dynamic> values) {
    final placeholders = List.filled(values.length, '?').join(', ');
    _sqlStatement += _whereAdded ? ' AND' : ' WHERE';
    _sqlStatement += ' $column IN ($placeholders)';
    _whereAdded = true;
    _parameters.addAll(values);
    return this;
  }

  QueryBuilder greaterThan(String column, dynamic value) {
    return where('$column > ?', value);
  }

  QueryBuilder greaterThanOrEquals(String column, dynamic value) {
    return where('$column >= ?', value);
  }

  QueryBuilder lessThan(String column, dynamic value) {
    return where('$column < ?', value);
  }

  QueryBuilder lessThanOrEquals(String column, dynamic value) {
    return where('$column <= ?', value);
  }

  QueryBuilder between(String column, dynamic start, dynamic end) {
    _sqlStatement += _whereAdded ? ' AND' : ' WHERE';
    _sqlStatement += ' $column BETWEEN ? AND ?';
    _whereAdded = true;
    _parameters.addAll([start, end]);
    return this;
  }

  QueryBuilder or([String condition = '', dynamic value]) {
    _sqlStatement += ' OR $condition';
    if (value != null) _parameters.add(value);
    return this;
  }

  QueryBuilder and([String condition = '', dynamic value]) {
    _sqlStatement += ' AND $condition';
    if (value != null) _parameters.add(value);
    return this;
  }

  QueryBuilder startBlock() {
    _sqlStatement += ' (';
    _blockStarted = true;
    return this;
  }

  QueryBuilder endBlock() {
    if (_blockStarted) {
      _sqlStatement += ')';
      _blockStarted = false;
    }
    return this;
  }

  QueryBuilder join(String table, {String onClause = ''}) {
    _sqlStatement += ' JOIN $table ON $onClause';
    return this;
  }

  QueryBuilder orderBy(String column, {bool descending = false}) {
    _sqlStatement += ' ORDER BY $column ${descending ? 'DESC' : 'ASC'}';
    return this;
  }

  QueryBuilder limit(int count) {
    _sqlStatement += ' LIMIT ?';
    _parameters.add(count);
    return this;
  }
}
