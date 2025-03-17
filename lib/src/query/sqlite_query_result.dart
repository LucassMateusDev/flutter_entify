import 'package:flutter/material.dart';
import 'package:entify/src/entities/db_entity.dart';
import 'package:entify/src/entities/mixins/db_entity_transformer.dart';

class SqliteQueryResult<T> with DbEntityTransformer<T> {
  List<Map<String, Object?>> result;

  @protected
  @override
  DbEntity<T> dbEntity;

  SqliteQueryResult(this.dbEntity, this.result);

  List<T> get entities {
    return result.map(dbEntity.mapToEntity).toList();
  }

  T? get firstOrNull {
    if (result.isEmpty) return null;

    return dbEntity.mapToEntity(result.first);
  }
}
