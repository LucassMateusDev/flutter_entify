// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/mixins/sqlite_commom_operations.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/mixins/sqlite_commom_transaction_operations.dart';
import 'package:sqflite_entity_mapper_orm/src/db_operations/mixins/sqlite_entity_operations.dart';
import 'package:sqflite_entity_mapper_orm/src/transactions/sqlite_db_transaction.dart';

import '../connection/sqlite_db_connection.dart';
import '../entities/db_entity_service.dart';

import '../query/db_query.dart';
import '../entities/db_entity.dart';

class DbSet<T> with SqliteCommomOperations<T>, SqliteEntityOperations<T> {
  late final DbEntity<T> _dbEntity;
  late final SqliteDbConnection _connection;

  @override
  DbEntity<T> get dbEntity {
    return _dbEntity;
  }

  @override
  SqliteDbConnection get connection => _connection;

  DbQuery<T> get query => DbQuery<T>(dbEntity, connection);

  SqliteCommomTransactionOperations<T> transaction(
      SqliteDbTransaction transaction) {
    return SqliteCommomTransactionOperations<T>(transaction, dbEntity);
  }

  void initialize(DbEntityService service, SqliteDbConnection connection) {
    _dbEntity = service.get<T>();
    _connection = connection;
  }

  Future<void> merge(List<T> entities) async {
    final transaction = _connection.getTransaction;

    try {
      for (final entity in entities) {
        final values = dbEntity.toUpdateOrInsert(entity);

        if (await exists(entity)) {
          final primaryKey = dbEntity.primaryKey(entity);
          final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
          final args = primaryKey.values.toList();

          transaction.update(
            dbEntity.name,
            values,
            where: clause,
            whereArgs: args,
          );
        } else {
          transaction.insert(
            dbEntity.name,
            values,
          );
        }
      }
    } catch (e) {
      debugPrint('Erro no mergeDefault: $e');
      rethrow;
    }
  }

  Future<List<Object?>> mergeCustom(
    List<T> entities, {
    required Future<bool> Function(T entity) shouldUpdate,
    required Future<bool> Function(T entity) shouldInsert,
    bool removeWhenNotMatchAny = false,
    bool noResult = false,
  }) async {
    //TODO: Ajustar Merge
    /*
    MERGE 
    dbo.Dim_Venda AS Destino
    USING 
    dbo.Venda AS Origem ON (Origem.Id_Venda = Destino.Id_Venda)

    -- Registro existe nas 2 tabelas
    WHEN MATCHED THEN
        UPDATE SET 
            Destino.Dt_Venda = Origem.Dt_Venda,
            Destino.Id_Produto = Origem.Id_Produto,
            Destino.Quantidade = Origem.Quantidade,
            Destino.Valor = Origem.Valor

    -- Registro não existe no destino. Vamos inserir.
    WHEN NOT MATCHED THEN
        INSERT
        VALUES(Origem.Id_Venda, Origem.Dt_Venda, Origem.Id_Produto, Origem.Quantidade, Origem.Valor);
    */

    final transaction = _connection.getTransaction;
    try {
      final Set<T> shouldUpdateMap = {};
      final Set<T> shouldInsertMap = {};

      for (final entity in entities) {
        if (await shouldUpdate(entity)) {
          shouldUpdateMap.add(entity);

          final values = dbEntity.toUpdateOrInsert(entity);
          final primaryKey = dbEntity.primaryKey(entity);
          final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
          final args = primaryKey.values.toList();

          transaction.update(
            dbEntity.name,
            values,
            where: clause,
            whereArgs: args,
          );
        }

        if (await shouldInsert(entity)) {
          shouldInsertMap.add(entity);

          final values = dbEntity.toUpdateOrInsert(entity);

          transaction.insert(
            dbEntity.name,
            values,
          );
        }
      }

      if (removeWhenNotMatchAny) {
        for (final entity in entities) {
          final shouldRemove = !(shouldInsertMap.contains(entity) ||
              shouldUpdateMap.contains(entity));

          if (shouldRemove) {
            final primaryKey = dbEntity.primaryKey(entity);
            final clause =
                primaryKey.keys.map((key) => '$key = ?').join(' AND ');
            final args = primaryKey.values.toList();

            transaction.delete(
              dbEntity.name,
              where: clause,
              whereArgs: args,
            );
          }
        }
      }

      final results = await transaction.commit(noResult: noResult);
      return results;
    } finally {
      transaction.close();
    }
  }

  Future<void> mergeInTransaction(
    List<T> entities, {
    required SqliteDbTransaction transaction,
    required Future<bool> Function(T entity) shouldUpdate,
    required Future<bool> Function(T entity) shouldInsert,
    bool removeWhenNotMatchAny = false,
  }) async {
    final Set<T> shouldUpdateMap = {};
    final Set<T> shouldInsertMap = {};

    for (final entity in entities) {
      if (await shouldUpdate(entity)) {
        shouldUpdateMap.add(entity);

        final values = dbEntity.toUpdateOrInsert(entity);
        final primaryKey = dbEntity.primaryKey(entity);
        final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
        final args = primaryKey.values.toList();

        transaction.update(
          dbEntity.name,
          values,
          where: clause,
          whereArgs: args,
        );
      }

      if (await shouldInsert(entity)) {
        shouldInsertMap.add(entity);

        final values = dbEntity.toUpdateOrInsert(entity);

        transaction.insert(
          dbEntity.name,
          values,
        );
      }
    }

    if (removeWhenNotMatchAny) {
      for (final entity in entities) {
        final shouldRemove = !(shouldInsertMap.contains(entity) ||
            shouldUpdateMap.contains(entity));

        if (shouldRemove) {
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
    }
  }
}
