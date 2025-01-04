import 'package:sqflite_entity_mapper_orm/src/entities/db_entity.dart';

mixin DbEntityTransformer<T> {
  DbEntity<T> get dbEntity;

  T toEntity(Map<String, Object?> map) {
    return dbEntity.mapToEntity(map);
  }

  Map<String, Object?> toUpdateOrInsert(T entity) {
    return dbEntity.toUpdateOrInsert(entity);
  }
}
