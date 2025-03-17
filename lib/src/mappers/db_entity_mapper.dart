import 'package:entify/sqflite_entity_mapper_orm.dart';

class DbEntityMapper<T, R> {
  DbEntityMapper(this.mapping);

  T Function(R) mapping;

  void create() => CreateDbMap(this);
}
