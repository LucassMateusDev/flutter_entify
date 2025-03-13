import 'dart:async';

import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

mixin DbAutoEntityRegister on DbContext {
  List<DbEntity> get entities;

  @override
  FutureOr<void> binds() {
    registerEntities(entities);
    return super.binds();
  }
}
