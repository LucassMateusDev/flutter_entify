import 'package:sqflite_entity_mapper_orm/src/entities/db_entity.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity_service.dart';

class DbEntityRegister<T> {
  final DbEntity<T> entity;

  DbEntityRegister(this.entity) {
    DbEntityService.i.register(entity);
  }
}
