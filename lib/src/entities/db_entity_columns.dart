import 'dart:convert';

import 'package:sqflite_entity_mapper_orm/sqflite_entity_mapper_orm.dart';

enum ColumnType {
  integer('INTEGER'),
  text('TEXT'),
  real('REAL'),
  blob('BLOB'),
  numeric('NUMERIC');

  final String toText;
  const ColumnType(this.toText);
}

class DbEntityColumn {
  final String name;
  final ColumnType type;
  final bool isPrimaryKey;
  final bool isNullable;
  final bool isAutoIncrement;
  final dynamic defaultValue;
  final List<ForeignKey> foreignKeys;

  DbEntityColumn({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isNullable = true,
    this.isAutoIncrement = false,
    this.defaultValue,
    this.foreignKeys = const [],
  }) : assert(name.isNotEmpty, 'Column name cannot be empty') {
    if (isPrimaryKey) {
      assert(!isNullable, 'Primary key cannot be nullable. Column: $name');
    }
    if (isAutoIncrement) {
      assert(
        type == ColumnType.integer,
        'Autoincrement must be an integer. Column: $name, Type: $type',
      );
      assert(!isNullable, 'Autoincrement cannot be nullable. Column: $name');
      assert(
        isPrimaryKey,
        'Autoincrement must be a primary key. Column: $name',
      );
    }
  }

  bool get hasForeignKey => foreignKeys.isNotEmpty;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.toText,
      'isPrimaryKey': isPrimaryKey,
      'isNullable': isNullable,
      'isAutoIncrement': isAutoIncrement,
      'defaultValue': defaultValue,
    };
  }

  factory DbEntityColumn.fromMap(Map<String, dynamic> map) {
    return DbEntityColumn(
      name: map['name'],
      type: ColumnType.values.firstWhere(
        (e) => e.toText == map['type'],
      ),
      isPrimaryKey: map['isPrimaryKey'],
      isNullable: map['isNullable'],
      isAutoIncrement: map['isAutoIncrement'],
      defaultValue: map['defaultValue'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DbEntityColumn &&
        other.name == name &&
        other.type == type &&
        other.isPrimaryKey == isPrimaryKey &&
        other.isNullable == isNullable &&
        other.isAutoIncrement == isAutoIncrement &&
        other.defaultValue == defaultValue &&
        other.foreignKeys == foreignKeys;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        isPrimaryKey.hashCode ^
        isNullable.hashCode ^
        isAutoIncrement.hashCode ^
        defaultValue.hashCode ^
        foreignKeys.hashCode;
  }

  bool isOnlyNameChanged(DbEntityColumn other) {
    return other.name != name &&
        other.type == type &&
        other.isPrimaryKey == isPrimaryKey &&
        other.isNullable == isNullable &&
        other.isAutoIncrement == isAutoIncrement &&
        other.defaultValue == defaultValue &&
        other.foreignKeys == foreignKeys;
  }

  bool isOnlyFKsChanged(DbEntityColumn other) {
    return other.name == name &&
        other.type == type &&
        other.isPrimaryKey == isPrimaryKey &&
        other.isNullable == isNullable &&
        other.isAutoIncrement == isAutoIncrement &&
        other.defaultValue == defaultValue &&
        other.foreignKeys != foreignKeys;
  }
}

class IntColumn extends DbEntityColumn {
  IntColumn({
    required super.name,
    super.isPrimaryKey,
    super.isNullable,
    super.isAutoIncrement,
    super.defaultValue,
    super.foreignKeys = const [],
  }) : super(type: ColumnType.integer);
}

class TextColumn extends DbEntityColumn {
  TextColumn({
    required super.name,
    super.isPrimaryKey,
    super.isNullable,
    super.defaultValue,
    super.foreignKeys = const [],
  }) : super(type: ColumnType.text);
}

class RealColumn extends DbEntityColumn {
  RealColumn({
    required super.name,
    super.isPrimaryKey,
    super.isNullable,
    super.defaultValue,
    super.foreignKeys = const [],
  }) : super(type: ColumnType.real);
}

class BlobColumn extends DbEntityColumn {
  BlobColumn({
    required super.name,
    super.isPrimaryKey,
    super.isNullable,
    super.defaultValue,
    super.foreignKeys = const [],
  }) : super(type: ColumnType.blob);
}

class NumericColumn extends DbEntityColumn {
  NumericColumn({
    required super.name,
    super.isPrimaryKey,
    super.isNullable,
    super.defaultValue,
    super.foreignKeys = const [],
  }) : super(type: ColumnType.numeric);
}

class BoolColumn extends IntColumn {
  BoolColumn({
    required super.name,
    super.isPrimaryKey,
    super.isNullable,
    bool defaultValue = false,
    super.foreignKeys = const [],
  }) : super(defaultValue: defaultValue ? 1 : 0);
}
