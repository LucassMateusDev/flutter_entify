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
      throw Exception('Entity already registered for type $T');
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
