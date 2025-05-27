import 'package:flutter/material.dart';

import '../exceptions/entify_exception.dart';
import '../set/db_set.dart';

abstract class SqliteGenericRepository<T> {
  @protected
  final DbSet<T> dbSet;

  SqliteGenericRepository({required this.dbSet});

  Future<void> update(T entity) async => dbSet.updateAsync(entity);

  Future<void> remove(T entity) async => dbSet.deleteAsync(entity);

  Future<T?> get(T entity) async => dbSet.selectAsync(entity);

  Future<T> save(T entity) async {
    final id = await dbSet.insertAsync(entity);

    final result = await dbSet.findFirstOrNull('id = ?', [id]);

    if (result == null) throw EntifyException('Error saving entity');

    return result;
  }
}
