import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

mixin DbAutoEntityMapper on DbContext {
  List<DbEntityMapperProvider> get dbMappingsProvider;

  @override
  List<DbEntityMapper> get dbMappings => dbMappingsProvider
      .map((provider) => provider.dbMappings)
      .expand((element) => element)
      .toList();

  void registerAutoMappings() {
    for (final provider in dbMappingsProvider) {
      provider.createMappings();
    }
  }
}
