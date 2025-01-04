// // ignore_for_file: unused_import, depend_on_referenced_packages


// import '../annotations/sqlite_annotations.dart'; // Importar as anotações definidas

// class MigrationGenerator extends GeneratorForAnnotation<Entity> {
//   @override
//   generateForAnnotatedElement(
//       Element element, ConstantReader annotation, BuildStep buildStep) {
//     if (element is! ClassElement) return null;

//     // ignore: prefer_const_declarations
//     final isNewDataBaseEntity = false;
//     final className = element.name;
//     final tableName =
//         annotation.peek('tableName')?.stringValue ?? className.toLowerCase();

//     // Recuperar as colunas
//     final fields = element.fields
//         .where((field) => field.metadata.any((m) => m.element is Column));

//     var columns = fields.map((field) {
//       final columnAnnotation = field.metadata
//           .firstWhere((m) => m.element is Column)
//           .computeConstantValue();
//       if (columnAnnotation == null) return '';

//       final columnName =
//           columnAnnotation.getField('columnName')?.toStringValue() ??
//               field.name;
//       final isPrimaryKey =
//           columnAnnotation.getField('isPrimaryKey')?.toBoolValue() ?? false;
//       final isNullable =
//           columnAnnotation.getField('isNullable')?.toBoolValue() ?? true;
//       final isAutoIncrement =
//           columnAnnotation.getField('isAutoIncrement')?.toBoolValue() ?? false;

//       String sql = '$columnName ${_getSqlType(field)}';
//       if (isPrimaryKey) sql += ' PRIMARY KEY';
//       if (isAutoIncrement) sql += ' AUTOINCREMENT';
//       if (!isNullable) sql += ' NOT NULL';

//       return sql;
//     }).join(', ');

//     final String sqlScript = isNewDataBaseEntity
//         ?
//         // ignore: dead_code
//         ''''''
//         : '''create table $tableName ( $columns )''';

//     return '''class ${className}Migration implements IMigration {
//         @override
//         void create(Batch batch) {
//           batch.execute($sqlScript)
//         }
//         @override
//         void update(Batch batch) {
//         }

//       } ''';
//   }

//   String _getSqlType(FieldElement field) {
//     if (field.type.isDartCoreInt) {
//       return 'INTEGER';
//     } else if (field.type.isDartCoreString) {
//       return 'TEXT';
//     }
//     return 'TEXT';
//   }
// }
