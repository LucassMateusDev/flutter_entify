import 'package:sqflite_common/sqlite_api.dart';

class BatchSchemaExecutor {
  final Batch _batch;

  BatchSchemaExecutor(this._batch);

  void execute(String sql) {
    _batch.execute(sql);
  }
}
