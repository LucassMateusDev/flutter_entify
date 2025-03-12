import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

import '../exceptions/sqlite_data_mapper_exception.dart';

class DbEntityBuilder<T> {
  String _name = '';
  T Function(Map<String, dynamic>)? _mapToEntity;
  Map<String, dynamic> Function(T e) _toUpdateOrInsert = (T e) => {};
  Map<String, dynamic> Function(T e) _primaryKey = (T e) => {};
  List<Map<String, dynamic>> Function(T e) _uniqueKeys = (T e) => [];
  List<DbEntityColumn> _columns = [];

  String get entityName => _name.isEmpty ? T.toString() : _name;

  DbEntityBuilder<T> name(String name) {
    _name = name;
    return this;
  }

  DbEntityBuilder<T> mapToEntity(
    T Function(Map<String, dynamic> map) mapToEntity,
  ) {
    _mapToEntity = mapToEntity;
    return this;
  }

  DbEntityBuilder<T> toUpdateOrInsert(
      Map<String, dynamic> Function(T e) toUpdateOrInsert) {
    _toUpdateOrInsert = toUpdateOrInsert;
    return this;
  }

  DbEntityBuilder<T> primaryKey(Map<String, dynamic> Function(T e) primaryKey) {
    _primaryKey = primaryKey;
    return this;
  }

  DbEntityBuilder<T> uniqueKeys(
    List<Map<String, dynamic>> Function(T e) uniqueKeys,
  ) {
    _uniqueKeys = uniqueKeys;
    return this;
  }

  DbEntityBuilder<T> columns(List<DbEntityColumn> columns) {
    _columns = columns;
    return this;
  }

  DbEntityBuilder<T> addColumn(DbEntityColumn column) {
    _columns.add(column);
    return this;
  }

  DbEntity<T> build() {
    if (_mapToEntity == null) {
      throw SqliteDataMapperException(
          'mapToEntity is required to build DbEntity');
    }

    return DbEntity<T>(
      name: entityName,
      mapToEntity: _mapToEntity!,
      toUpdateOrInsert: _toUpdateOrInsert,
      primaryKey: _primaryKey,
      uniqueKeys: _uniqueKeys,
      columns: _columns,
    );
  }
}
