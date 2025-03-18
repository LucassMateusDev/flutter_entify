import 'package:entify/entify.dart';

import '../exceptions/sqlite_data_mapper_exception.dart';
import 'db_entity.dart';

class DbEntityService {
  static DbEntityService? _instance = DbEntityService._();

  static DbEntityService get i {
    _instance ??= DbEntityService._();
    return _instance!;
  }

  DbEntityService._();

  final Map<String, DbEntity> _entityMap = {};

  Map<String, DbEntity> get entities => _entityMap;

  void register<T>(DbEntity<T> entity) {
    final key = getEntityKey<T>();

    if (_entityMap.containsKey(key)) {
      throw SqliteDataMapperException('Entity already registered for type $T');
    }

    _entityMap[key] = entity;
  }

  DbEntity<T> get<T>() {
    final key = getEntityKey<T>();

    if (!_entityMap.containsKey(key)) {
      throw ("Entity ${T.toString()} not registered in DbEntityService.");
    }

    return _entityMap[key] as DbEntity<T>;
  }

  void unRegister<T>() {
    final key = getEntityKey<T>();
    _entityMap.remove(key);
  }

  String getEntityKey<T>() => T.toString();
}

// extension DbEntityServiceExtensions on DbEntityService {
//   List<DbEntityAutoUpdate> getRelatedEntities<T>() {
//     final dbEntity = get<T>();
//     final key = getEntityKey<T>();
//     final relatedEntities = <DbEntityAutoUpdate>[];

//     final columnsWithFk = getAllColumnsWithFk();

//     final relatedFks = getAllRelatedFks<T>();
//     // debugPrint('columnsWithFk: $columnsWithFk');

//     for (final fk in relatedFks) {
//       final entity = _entityMap[fk.entityKey];
//       final column = columnsWithFk.firstWhere(
//         (c) => c.foreignKeys.contains(fk),
//       );
//       if (entity != null) {
//         relatedEntities.add(DbEntityAutoUpdate(
//           entity: entity,
//           column: column,
//           fk: fk,
//         ));
//       }
//     }

//     return relatedEntities;
//   }

//   List<DbEntityColumn> getAllColumnsWithFk() {
//     List<DbEntityColumn> columnsWithFk = [];

//     for (final entity in _entityMap.values) {
//       columnsWithFk.addAll(
//         entity.columns.where((c) => c.hasForeignKey).toList(),
//       );
//     }

//     return columnsWithFk;
//   }

//   List<ForeignKey> getAllRelatedFks<T>() {
//     final dbEntity = get<T>();
//     final columnsWithFk = getAllColumnsWithFk();

//     final relatedFks = columnsWithFk
//         .map((e) => e.foreignKeys)
//         .expand((e) => e)
//         .where((e) => e.referencedEntity == dbEntity.name)
//         .toList();

//     return relatedFks;
//   }
// }
