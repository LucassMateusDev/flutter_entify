import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

abstract class DbContext {
  final DbEntityService dbEntityService;
  final SqliteDbConnection dbConnection;

  DbContext({
    required this.dbEntityService,
    required this.dbConnection,
  });

  List<DbSet> get dbSets;
  List<DbEntityRegister> get dbEntities => [];
  List<CreateMap> get mappings => [];

  void onInit() {
    dbSetsInitialize(dbSets);
  }

  void binds();

  void initialize() {
    binds();
    onInit();
  }

  void addAutoMappings(DbCreateMapperProvider mapper) =>
      mappings.addAll(mapper.mappings);

  void registerAutoEntities(DbEntityRegisterProvider db) =>
      dbEntities.addAll(db.entities);

  void dbSetsInitialize(List<DbSet> dbSets) {
    for (var set in dbSets) {
      set.initialize(dbEntityService, dbConnection);
    }
  }
}
