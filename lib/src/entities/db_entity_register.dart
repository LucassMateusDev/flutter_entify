import 'package:flutter_entify/src/entities/db_entity.dart';
import 'package:flutter_entify/src/entities/db_entity_service.dart';

class DbEntityRegister<T> {
  final DbEntity<T> entity;

  DbEntityRegister(this.entity) {
    DbEntityService.i.register(entity);
  }
}
