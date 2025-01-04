import 'dart:async';

import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

abstract interface class DbOperation<E, R> {
  FutureOr<R> call(
    SqliteDbConnection connection,
    DbEntity<E> dbEntity,
    E entity,
  );
}
