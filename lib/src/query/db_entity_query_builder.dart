import 'package:flutter/material.dart';

import 'package:entify/src/db_operations/mixins/sqlite_query_builder_operations.dart';
import 'package:entify/src/entities/db_entity.dart';
import 'package:entify/src/query/query_builder.dart';

class DbEntityQueryBuilder<T> extends QueryBuilder
    with SqliteDbEntityQueryBuilderOperations<T> {
  DbEntityQueryBuilder(
    this.dbEntity,
    super.connection,
    List<String>? columns,
  ) {
    super.select(columns ?? []);
    super.from(dbEntity.name);
  }

  @protected
  @override
  final DbEntity<T> dbEntity;

  String get tableName => dbEntity.name;

  @override
  DbEntityQueryBuilder<T> where(String condition, [dynamic value]) {
    super.where(condition);
    return this;
  }

  @override
  DbEntityQueryBuilder<T> not([String condition = '', dynamic value]) {
    super.not(condition);
    return this;
  }

  @override
  DbEntityQueryBuilder<T> equals(String column, dynamic value) {
    return where('$column = $value');
  }

  @override
  DbEntityQueryBuilder<T> notEquals(String column, dynamic value) {
    return where('$column <> $value');
  }

  @override
  DbEntityQueryBuilder<T> inValues(String column, List<dynamic> values) {
    final formattedValues = values.map((v) => v.toString()).join(', ');
    return where('$column IN ($formattedValues)');
  }

  @override
  DbEntityQueryBuilder<T> greaterThan(String column, dynamic value) {
    return where('$column > $value');
  }

  @override
  DbEntityQueryBuilder<T> greaterThanOrEquals(String column, dynamic value) {
    return where('$column >= $value');
  }

  @override
  DbEntityQueryBuilder<T> lessThan(String column, dynamic value) {
    return where('$column < $value');
  }

  @override
  DbEntityQueryBuilder<T> lessThanOrEquals(String column, dynamic value) {
    return where('$column <= $value');
  }

  @override
  DbEntityQueryBuilder<T> between(String column, dynamic start, dynamic end) {
    return where('$column BETWEEN $start AND $end');
  }

  @override
  DbEntityQueryBuilder<T> or([String condition = '', dynamic value]) {
    super.or(condition);
    return this;
  }

  @override
  DbEntityQueryBuilder<T> and([String condition = '', dynamic value]) {
    super.and(condition);
    return this;
  }

  @override
  DbEntityQueryBuilder<T> startBlock() {
    super.startBlock();
    return this;
  }

  @override
  DbEntityQueryBuilder<T> endBlock() {
    super.endBlock();
    return this;
  }

  @override
  DbEntityQueryBuilder<T> join(String table, {String onClause = ''}) {
    super.join(table, onClause: onClause);
    return this;
  }

  @override
  DbEntityQueryBuilder<T> orderBy(String column, {bool descending = false}) {
    super.orderBy(column, descending: descending);
    return this;
  }

  @override
  DbEntityQueryBuilder<T> limit(int count) {
    super.limit(count);
    return this;
  }
}
