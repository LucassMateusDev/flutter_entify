import 'dart:convert';

import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';
import 'package:sqflite_entity_mapper_orm/src/entities/db_entity_definition.dart';

class MigrationMetadata {
  final String entityName;
  final String columnDefinitions;
  final DateTime lastModified;

  MigrationMetadata({
    required this.entityName,
    required this.columnDefinitions,
    required this.lastModified,
  });

  MigrationMetadata copyWith({
    String? entityName,
    String? columnDefinitions,
    DateTime? lastModified,
  }) {
    return MigrationMetadata(
      entityName: entityName ?? this.entityName,
      columnDefinitions: columnDefinitions ?? this.columnDefinitions,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entityName': entityName,
      'columnDefinitions': columnDefinitions,
      'lastModified': lastModified,
    };
  }

  Map<String, dynamic> upSave() {
    return {
      'entity_name': entityName,
      'column_definitions': columnDefinitions,
      'last_modified': DateTime.now().toIso8601String(),
    };
  }

  factory MigrationMetadata.fromMap(Map<String, dynamic> map) {
    final entityName = map['entity_name'] as String;
    final columnDefinitions = map['column_definitions'] as String;
    final lastModified = DateTime.parse(map['last_modified'] as String);

    return MigrationMetadata(
      entityName: entityName,
      columnDefinitions: columnDefinitions,
      lastModified: lastModified,
    );
  }

  String toJson() => json.encode(toMap());

  factory MigrationMetadata.fromJson(String source) =>
      MigrationMetadata.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MigrationMetadata(entityName: $entityName, columnDefinitions: $columnDefinitions, lastModified: $lastModified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MigrationMetadata &&
        other.entityName == entityName &&
        other.columnDefinitions == columnDefinitions &&
        other.lastModified == lastModified;
  }

  @override
  int get hashCode {
    return entityName.hashCode ^
        columnDefinitions.hashCode ^
        lastModified.hashCode;
  }

  factory MigrationMetadata.fromDbEntityDefinition(DbEntityDefinition entity) {
    return MigrationMetadata(
      entityName: entity.tableName,
      columnDefinitions: entity.columnsToJson(),
      lastModified: entity.lastModified,
    );
  }

  DbEntityDefinition toDbEntityDefinition() {
    return DbEntityDefinition(
      tableName: entityName,
      columns: json
          .decode(columnDefinitions)
          .map<DbEntityColumn>((e) => DbEntityColumn.fromMap(e))
          .toList(),
      lastModified: lastModified,
    );
  }
}
