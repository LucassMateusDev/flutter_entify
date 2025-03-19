import 'package:entify/entify.dart';

class DbEntityMapper<T, R> {
  DbEntityMapper(this.mapping);

  T Function(R) mapping;

  void create() => CreateDbMap(this);
}
