import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

abstract class DbEntityRegisterProvider {
  List<DbEntity> get entities;

  void registerEntities() {
    for (final entity in entities) {
      entity.register();
    }
  }
}
