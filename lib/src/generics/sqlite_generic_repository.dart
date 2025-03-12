import 'package:flutter/material.dart';

import '../exceptions/sqlite_data_mapper_exception.dart';
import '../set/db_set.dart';

abstract class SqliteGenericRepository<T> {
  @protected
  final DbSet<T> dbSet;

  SqliteGenericRepository({required this.dbSet});

  Future<void> update(T entity) async => dbSet.update(entity);

  Future<void> remove(T entity) async => dbSet.delete(entity);

  Future<T?> get(T entity) async => dbSet.select(entity);

  Future<T> save(T entity) async {
    final id = await dbSet.insert(entity);

    final result = await dbSet.findFirstOrNull('id = ?', [id]);

    if (result == null) throw SqliteDataMapperException('Error saving entity');

    return result;
  }
}
