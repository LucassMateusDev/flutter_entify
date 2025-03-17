import 'package:entify/src/entities/db_entity.dart';
import 'package:entify/src/entities/db_entity_builder.dart';

abstract class DbEntityProvider<T> {
  DbEntityBuilder<T> builder = DbEntityBuilder<T>();

  DbEntity get entity;
}
