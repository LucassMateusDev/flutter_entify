import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

class DbEntityRegister<T> {
  final DbEntity<T> entity;

  DbEntityRegister(this.entity) {
    DbEntityService.i.register(entity);
  }
}
