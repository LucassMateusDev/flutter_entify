import 'dart:async';

import 'package:flutter_entify/flutter_entify.dart';

abstract interface class DbOperation<E, R> {
  FutureOr<R> call(
    SqliteDbConnection connection,
    DbEntity<E> dbEntity,
    E entity,
  );
}
