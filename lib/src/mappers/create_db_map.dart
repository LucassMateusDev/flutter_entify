import 'package:dart_class_mapper/dart_class_mapper.dart';
import 'package:sqflite_entity_mapper_orm/src/mappers/db_entity_mapper.dart';

class CreateDbMap<T, R> {
  final DbEntityMapper<T, R> entityMapper;
  CreateDbMap(this.entityMapper) {
    CreateMap(entityMapper.mapping);
  }
}
