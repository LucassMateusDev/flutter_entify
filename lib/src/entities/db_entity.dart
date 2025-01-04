import 'package:sqflite_entity_mapper_orm/src/entities/db_entity_columns.dart';

class DbEntity<T> {
  final String name;
  final T Function(Map<String, dynamic>) mapToEntity;
  final Map<String, dynamic> Function(T e) toUpdateOrInsert;
  final Map<String, dynamic> Function(T e) primaryKey;
  final List<Map<String, dynamic>> Function(T e) uniqueKeys;
  // final List<ForeignKey<T, dynamic>>? foreingKeys;
  final List<DbEntityColumn> columns;
  // final Map<String, List<String>> indexes;

  DbEntity({
    required this.name,
    required this.mapToEntity,
    required this.toUpdateOrInsert,
    required this.primaryKey,
    required this.columns,
    // List<Map<String, dynamic>> Function(T)? uniqueKeys,
    List<Map<String, dynamic>> Function(T e)? uniqueKeys,
    // this.foreingKeys,
    // this.indexes = const {},
  }) : uniqueKeys = uniqueKeys ?? ((T e) => []);

  bool hasPrimaryKey(T entity) => primaryKey(entity).isNotEmpty;
  bool hasUniqueKeys(T entity) => uniqueKeys(entity).isNotEmpty;
}

// //TODO: Verificar a implementação de foreignkeys
// class ForeignKey<T, F> {
//   final String relatedEntity;
//   final dynamic Function(F entity) relatedPrimaryKeyField;
//   final dynamic Function(T entity) getForeignKeyValue;

//   ForeignKey({
//     required this.relatedEntity,
//     required this.relatedPrimaryKeyField,
//     required this.getForeignKeyValue,
//   });
// }
