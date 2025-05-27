import 'package:entify/src/entities/db_entity.dart';
import 'package:entify/src/entities/builder/db_entity_builder.dart';

abstract class DbEntityProvider<T> {
  DbEntityBuilder<T> get builder;

  DbEntity get entity => builder.build();
}
