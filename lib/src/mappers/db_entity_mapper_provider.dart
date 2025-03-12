import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

abstract class DbEntityMapperProvider {
  List<DbEntityMapper> get dbMappings;

  void createMappings() {
    for (final dbMapper in dbMappings) {
      dbMapper.create();
    }
  }
}
