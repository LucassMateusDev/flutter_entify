// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:entify/src/db_operations/mixins/sqlite_entity_operations.dart';
import 'package:entify/src/db_operations/mixins/sqlite_operations.dart';

import '../connection/sqlite_db_connection.dart';
import '../entities/db_entity_service.dart';

import '../query/db_query.dart';
import '../entities/db_entity.dart';

class DbSet<T> with SqliteOperations<T>, SqliteEntityOperations<T> {
  late final DbEntity<T> _dbEntity;
  late final SqliteDbConnection _connection;

  @override
  DbEntity<T> get dbEntity => _dbEntity;

  @override
  SqliteDbConnection get connection => _connection;

  DbEntityQuery<T> get query => DbEntityQuery<T>(dbEntity, connection);

  @protected
  void initialize(DbEntityService service, SqliteDbConnection connection) {
    _dbEntity = service.get<T>();
    _connection = connection;
  }
}
