import 'package:dart_class_mapper/dart_class_mapper.dart';
import 'package:entify/src/mappers/db_entity_mapper.dart';

class CreateDbMap<T, R> {
  final DbEntityMapper<T, R> entityMapper;
  CreateDbMap(this.entityMapper) {
    CreateMap(entityMapper.mapping);
  }
}
