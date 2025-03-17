import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:entify/sqflite_entity_mapper_orm.dart';

class DbEntityDefinition {
  int id;
  String tableName;
  List<DbEntityColumn> columns;
  DateTime lastModified;

  DbEntityDefinition({
    this.id = 0,
    required this.tableName,
    required this.columns,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableName': tableName,
      'columns': columns.map((e) => e.type.toText).toList(),
    };
  }

  String columnsToJson() {
    return json.encode(columns.map((e) => e.toMap()).toList());
  }

  Map<String, dynamic> columnsToMap() {
    return {
      'columns': columns.map((e) => e.toMap()).toList(),
    };
  }

  factory DbEntityDefinition.fromMap(Map<String, dynamic> map) {
    return DbEntityDefinition(
      id: map['id']?.toInt() ?? 0,
      tableName: map['tableName'],
      columns: List<DbEntityColumn>.from(
        map['columns'].map((e) => DbEntityColumn.fromMap(e)),
      ),
    );
  }

  factory DbEntityDefinition.fromDbEntity(DbEntity entity) {
    return DbEntityDefinition(
      tableName: entity.name,
      columns: entity.columns,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DbEntityDefinition &&
        other.tableName == tableName &&
        listEquals(other.columns, columns);
  }

  @override
  int get hashCode => tableName.hashCode ^ columns.hashCode;
}
