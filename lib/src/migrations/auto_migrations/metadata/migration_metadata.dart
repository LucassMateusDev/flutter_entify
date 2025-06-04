import 'dart:convert';

import 'package:entify/entify.dart';
import 'package:entify/src/entities/db_entity_definition.dart';

class MigrationMetadata {
  final String entityName;
  final String columnDefinitions;
  final DateTime lastModified;
  final int version;

  MigrationMetadata({
    required this.entityName,
    required this.columnDefinitions,
    required this.lastModified,
    required this.version,
  });

  MigrationMetadata copyWith({
    String? entityName,
    String? columnDefinitions,
    DateTime? lastModified,
    int? version,
  }) {
    return MigrationMetadata(
      entityName: entityName ?? this.entityName,
      columnDefinitions: columnDefinitions ?? this.columnDefinitions,
      lastModified: lastModified ?? this.lastModified,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entityName': entityName,
      'columnDefinitions': columnDefinitions,
      'lastModified': lastModified,
      'version': version,
    };
  }

  Map<String, dynamic> upSave() {
    return {
      'entity_name': entityName,
      'column_definitions': columnDefinitions,
      'last_modified': DateTime.now().toIso8601String(),
      'version': version,
    };
  }

  factory MigrationMetadata.fromMap(Map<String, dynamic> map) {
    final entityName = map['entity_name'] as String;
    final columnDefinitions = map['column_definitions'] as String;
    final lastModified = DateTime.parse(map['last_modified'] as String);
    final version = map['version'] as int;

    return MigrationMetadata(
      entityName: entityName,
      columnDefinitions: columnDefinitions,
      lastModified: lastModified,
      version: version,
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

  factory MigrationMetadata.fromDbEntityDefinition(
      DbEntityDefinition entity, int version) {
    return MigrationMetadata(
      entityName: entity.tableName,
      columnDefinitions: entity.columnsToJson(),
      lastModified: entity.lastModified,
      version: version,
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
