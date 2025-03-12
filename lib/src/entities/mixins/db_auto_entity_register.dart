// import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

// mixin DbAutoEntityRegister on DbContext {
//   List<DbEntityRegisterProvider> get dbEntitiesProvider;

//   @override
//   List<DbEntity> get dbEntities => dbEntitiesProvider
//       .map((provider) => provider.entities)
//       .expand((element) => element)
//       .toList();

//   void registerAutoEntities() {
//     for (final provider in dbEntitiesProvider) {
//       provider.registerEntities();
//     }
//   }
// }
