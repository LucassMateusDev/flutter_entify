import 'dart:async';

import 'package:flutter_entify/flutter_entify.dart';

mixin DbAutoEntityRegister on DbContext {
  List<DbEntity> get entities;

  @override
  FutureOr<void> binds() {
    registerEntities(entities);
    return super.binds();
  }
}
