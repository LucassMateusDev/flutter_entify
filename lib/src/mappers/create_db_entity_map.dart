import 'package:dart_class_mapper/dart_class_mapper.dart';

class CreateDbEntityMap<T, R> {
  T Function(R) mapping;

  CreateDbEntityMap(this.mapping);

  void create() => CreateMap<T, R>(mapping);
}
