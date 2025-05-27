// ignore: depend_on_referenced_packages
import 'package:entify/src/migrations/batch_schema_executor.dart';

abstract interface class IMigration {
  int get version;
  void execute(BatchSchemaExecutor executor);
}
