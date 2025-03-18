import 'dart:async';

import 'package:entify/entify.dart';

mixin DbAutoEntityMapper on DbContext {
  List<DbEntityMapper> get mappings;

  @override
  FutureOr<void> binds() {
    createMappings(mappings);
    return super.binds();
  }
}
