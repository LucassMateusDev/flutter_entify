import 'dart:async';

import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

mixin DbAutoEntityMapper on DbContext {
  List<DbEntityMapper> get mappings;

  @override
  FutureOr<void> binds() {
    createMappings(mappings);
    return super.binds();
  }
}
