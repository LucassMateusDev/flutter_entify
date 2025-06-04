import 'package:entify/entify.dart';
import 'package:entify/src/entities/builder/db_entity_builder_handler.dart';

import '../../exceptions/entify_exception.dart';

abstract interface class DbEntityBuilder<T> {
  DbEntity<T> build();
}

class DefaultDbEntityBuilder<T> implements DbEntityBuilder<T> {
  String _name = '';
  T Function(Map<String, dynamic>)? _mapToEntity;
  Map<String, dynamic> Function(T e) _toUpdateOrInsert = (T e) => {};
  Map<String, dynamic> Function(T e) _primaryKey = (T e) => {};
  List<Map<String, dynamic>> Function(T e) _uniqueKeys = (T e) => [];
  List<DbEntityColumn> _columns = [];

  DefaultDbEntityBuilder<T> name(String name) {
    _name = name;
    return this;
  }

  DefaultDbEntityBuilder<T> mapToEntity(
    T Function(Map<String, dynamic> map) mapToEntity,
  ) {
    _mapToEntity = mapToEntity;
    return this;
  }

  DefaultDbEntityBuilder<T> toUpdateOrInsert(
      Map<String, dynamic> Function(T e) toUpdateOrInsert) {
    _toUpdateOrInsert = toUpdateOrInsert;
    return this;
  }

  DefaultDbEntityBuilder<T> primaryKey(
      Map<String, dynamic> Function(T e) primaryKey) {
    _primaryKey = primaryKey;
    return this;
  }

  DefaultDbEntityBuilder<T> uniqueKeys(
    List<Map<String, dynamic>> Function(T e) uniqueKeys,
  ) {
    _uniqueKeys = uniqueKeys;
    return this;
  }

  DefaultDbEntityBuilder<T> columns(List<DbEntityColumn> columns) {
    _columns = columns;
    return this;
  }

  DefaultDbEntityBuilder<T> addColumn(DbEntityColumn column) {
    _columns.add(column);
    return this;
  }

  @override
  DbEntity<T> build() {
    if (_mapToEntity == null) {
      throw EntifyException('mapToEntity is required to build DbEntity');
    }

    return DbEntity<T>(
      name: DbEntityBuilderHandler.getTableName<T>(_name),
      mapToEntity: _mapToEntity!,
      toUpdateOrInsert: _toUpdateOrInsert,
      primaryKey: _primaryKey,
      uniqueKeys: _uniqueKeys,
      columns: _columns,
    );
  }
}

class SimpleEntityBuilder<T> implements DbEntityBuilder<T> {
  String _name = '';
  late Map<String, Type> _entityDefinition;
  late T Function(Map<String, dynamic>) _mapToEntity;
  late Map<String, dynamic> Function(T) _toUpdateOrInsert;

  SimpleEntityBuilder<T> name(String name) {
    _name = name;
    return this;
  }

  SimpleEntityBuilder<T> entityDefinition(Map<String, Type> definition) {
    _entityDefinition = definition;
    return this;
  }

  SimpleEntityBuilder<T> mapToEntity(T Function(Map<String, dynamic>) mapper) {
    _mapToEntity = mapper;
    return this;
  }

  SimpleEntityBuilder<T> toUpdateOrInsert(
      Map<String, dynamic> Function(T) toMap) {
    _toUpdateOrInsert = toMap;
    return this;
  }

  @override
  DbEntity<T> build() {
    return DbEntity<T>(
      name: DbEntityBuilderHandler.getTableName<T>(_name),
      mapToEntity: _mapToEntity,
      toUpdateOrInsert: _toUpdateOrInsert,
      primaryKey: (e) => {'id': (e as dynamic).id as int},
      columns: DbEntityBuilderHandler.inferColumnsFromDefinition(
        entityDefinition: _entityDefinition,
      ),
    );
  }
}
