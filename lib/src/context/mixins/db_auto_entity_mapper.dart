import 'dart:async';

import 'package:flutter_entify/flutter_entify.dart';

mixin DbAutoEntityMapper on DbContext {
  List<CreateDbEntityMap> get mappings;

  @override
  FutureOr<void> binds() {
    createMappings(mappings);
    return super.binds();
  }
}
