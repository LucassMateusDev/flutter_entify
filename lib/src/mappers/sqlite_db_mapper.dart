// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';

import '../annotations/sqlite_annotations.dart';
import '../connection/sqlite_connection_factory.dart';

class SqliteDbMapper {
  final SqliteConnectionFactory _connection = SqliteConnectionFactory.i;
  final List<Entity> _entities = [];

  static SqliteDbMapper? _instance;

  static SqliteDbMapper get i {
    _instance ??= SqliteDbMapper._();

    return _instance!;
  }

  SqliteDbMapper._() {
    // onInit();
  }

  // Tabelas que serão ignoradas durante o mapeamento
  final Set<String> _ignoreTables = {
    'android_metadata',
    'sqlite_sequence',
  };

  Future<void> initialize() async {
    final tables = await listTables();
    addEntities(tables);
  }

  void addEntities(List<Entity> entities) {
    _entities.addAll(entities);
  }

  Entity? getEntity(String tableName) =>
      _entities.firstWhereOrNull((t) => t.tableName == tableName);

  List<Entity> get entities => _entities;

  Future<List<Entity>> listTables() async {
    final List<Entity> tables = [];
    Database? cnx;

    try {
      cnx = await _connection.openConnection();

      final result = await cnx.rawQuery('''
        SELECT name 
        FROM sqlite_master 
        WHERE type = 'table' 
        ORDER BY name
      ''');

      for (var table in result) {
        final tblName = table['name'];

        if (tblName is String && !_ignoreTables.contains(tblName)) {
          // ignore: unused_local_variable
          final columns = await _listColumnsForTable(cnx, tblName);
          // final entity = Entity(tblName, columns);
          // tables.add(entity);
        }
      }
    } catch (e) {
      throw Exception('Erro ao mapear as tabelas do banco de dados: $e');
    } finally {
      await _connection.closeConnection();
    }

    return tables;
  }

  Future<List<Column>> _listColumnsForTable(
      Database cnx, String tableName) async {
    final List<Column> columns = [];

    try {
      final resultColumns =
          await cnx.rawQuery('PRAGMA table_info(\'$tableName\')');
      for (var column in resultColumns) {
        final columnName = column['name'];
        if (columnName is String) {
          columns.add(Column(columnName: columnName));
        }
      }
    } catch (e) {
      throw Exception('Erro ao listar colunas da tabela $tableName: $e');
    } finally {
      await _connection.closeConnection();
    }

    return columns;
  }
}
