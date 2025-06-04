import 'package:flutter_entify/flutter_entify.dart';

mixin SqliteEntityOperations<T> {
  SqliteDbConnection get connection;
  DbEntity<T> get dbEntity;

  Future<T?> findFirstOrNull(String condition, List<dynamic> values) async {
    final db = await connection.open();
    try {
      final result = await db.query(
        dbEntity.name,
        where: condition,
        whereArgs: values,
      );
      if (result.isEmpty) return null;

      return dbEntity.mapToEntity(result.first);
    } finally {
      await connection.close();
    }
  }

  Future<List<T>> findAll([String? condition, dynamic values]) async {
    final db = await connection.open();
    try {
      final result = await db.query(
        dbEntity.name,
        where: condition,
        whereArgs: values,
      );
      if (result.isNotEmpty) {
        return result.map(dbEntity.mapToEntity).toList();
      }
      return [];
    } finally {
      await connection.close();
    }
  }

  ///Só funciona quando a tabela tem uma chave primária chamada autoincrement
  Future<int> getNextInsertRowId() async {
    try {
      final db = await connection.open();
      final query = '''select seq + 1
                      from sqlite_sequence 
                      where name = "${dbEntity.name}"''';
      final queryResult = await db.rawQuery(query);

      if (queryResult.isEmpty) return 1;

      final id = queryResult.first.values.first as int;
      return id;
    } finally {
      connection.close();
    }
  }

  Future<bool> exists(
    T entity, {
    String customClause = '',
    List<Object?> customArguments = const [],
  }) async {
    try {
      bool exists = false;
      final db = await connection.open();

      if (customClause.isNotEmpty) {
        final result = await db.rawQuery(
          '''SELECT 1 FROM ${dbEntity.name} WHERE $customClause''',
          customArguments,
        );
        exists = result.isNotEmpty;

        return exists;
      }

      if (dbEntity.hasUniqueKeys(entity)) {
        exists = await _checkIfRecordExistsByUniqueKey(entity);
        return exists;
      }

      exists = await _checkIfRecordExistsByPrimaryKey(entity);

      return exists;
    } finally {
      await connection.close();
    }
  }

  Future<bool> _checkIfRecordExistsByUniqueKey(T entity) async {
    final db = await connection.open();
    final uniqueKeys = dbEntity.uniqueKeys(entity);

    for (final uniqueKey in uniqueKeys) {
      final clause = uniqueKey.keys.map((key) => '$key = ?').join(' AND ');
      final args = uniqueKey.values.toList();

      final query = '''SELECT 1 FROM ${dbEntity.name} 
                      WHERE $clause''';

      final result = await db.rawQuery(query, args);

      if (result.isNotEmpty) return true;
    }

    return false;
  }

  Future<bool> _checkIfRecordExistsByPrimaryKey(T entity) async {
    final db = await connection.open();
    final primaryKey = dbEntity
        .primaryKey(entity)
        .map((key, value) => MapEntry(key.toLowerCase(), value));

    if (primaryKey.isEmpty) return false;
    if (primaryKey.containsKey('id') &&
        (primaryKey['id'] == null || primaryKey['id'] < 1)) {
      return false;
    }

    final clause = primaryKey.keys.map((key) => '$key = ?').join(' AND ');
    final args = primaryKey.values.toList();

    final query = '''SELECT 1 FROM ${dbEntity.name} 
                      WHERE $clause''';

    final result = await db.rawQuery(query, args);

    return result.isNotEmpty;
  }
}
