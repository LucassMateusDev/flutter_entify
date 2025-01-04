import 'package:flutter/material.dart';
import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

class QueryBuilder {
  QueryBuilder(this.connection);

  @protected
  final SqliteDbConnection connection;

  String _sqlStatement = '';
  bool _whereAdded = false;
  bool _blockStarted = false;

  String get sqlStatement => _sqlStatement;

  void clearQuery() => _sqlStatement = '';

  QueryBuilder select([List<String> columns = const []]) {
    _sqlStatement = 'SELECT ${columns.isEmpty ? 'x.*' : columns.join(', ')}';
    return this;
  }

  QueryBuilder from(String tableName, [String alias = 'x']) {
    _sqlStatement += ' FROM $tableName x';
    return this;
  }

  QueryBuilder where(String condition) {
    if (!_whereAdded) {
      _sqlStatement += ' WHERE $condition';
      _whereAdded = true;
    } else {
      _sqlStatement += ' $condition';
    }
    return this;
  }

  QueryBuilder not([String condition = '']) {
    if (!_whereAdded) {
      _sqlStatement += ' WHERE NOT $condition';
      _whereAdded = true;
    } else {
      _sqlStatement += ' NOT $condition';
    }
    return this;
  }

  QueryBuilder equals(String column, dynamic value) {
    return where('$column = $value');
  }

  QueryBuilder notEquals(String column, dynamic value) {
    return where('$column <> $value');
  }

  QueryBuilder inValues(String column, List<dynamic> values) {
    final formattedValues = values.map((v) => v.toString()).join(', ');
    return where('$column IN ($formattedValues)');
  }

  QueryBuilder greaterThan(String column, dynamic value) {
    return where('$column > $value');
  }

  QueryBuilder greaterThanOrEquals(String column, dynamic value) {
    return where('$column >= $value');
  }

  QueryBuilder lessThan(String column, dynamic value) {
    return where('$column < $value');
  }

  QueryBuilder lessThanOrEquals(String column, dynamic value) {
    return where('$column <= $value');
  }

  QueryBuilder between(String column, dynamic start, dynamic end) {
    return where('$column BETWEEN $start AND $end');
  }

  QueryBuilder or([String condition = '']) {
    _sqlStatement += ' OR $condition';
    return this;
  }

  QueryBuilder and([String condition = '']) {
    _sqlStatement += ' AND $condition';
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
    _sqlStatement += ' LIMIT $count';
    return this;
  }
}
