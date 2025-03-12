import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

class DbEntity<T> {
  String name;
  T Function(Map<String, dynamic> map) mapToEntity;
  Map<String, dynamic> Function(T e) toUpdateOrInsert;
  Map<String, dynamic> Function(T e) primaryKey;
  List<Map<String, dynamic>> Function(T e) uniqueKeys;
  List<DbEntityColumn> columns;
  // final Map<String, List<String>> indexes;

  DbEntity({
    required this.name,
    required this.mapToEntity,
    required this.toUpdateOrInsert,
    required this.primaryKey,
    required this.columns,
    List<Map<String, dynamic>> Function(T e)? uniqueKeys,
    // this.indexes = const {},
  }) : uniqueKeys = uniqueKeys ?? ((T e) => []);

  void register() => DbEntityRegister(this);

  String get key => T.toString();
  bool get hasForeignKey => columns.any((c) => c.hasForeignKey);
  bool hasPrimaryKey(T entity) => primaryKey(entity).isNotEmpty;
  bool hasUniqueKeys(T entity) => uniqueKeys(entity).isNotEmpty;
}
