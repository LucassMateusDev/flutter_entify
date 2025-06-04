import 'dart:async';

import 'package:entify/entify.dart';

mixin DbAutoEntityRegister on DbContext {
  List<DbEntity> get entities;

  @override
  FutureOr<void> binds() {
    registerEntities(entities);
    return super.binds();
  }
}
