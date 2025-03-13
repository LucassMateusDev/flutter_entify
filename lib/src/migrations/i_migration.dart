// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

abstract interface class IMigration {
  void create(Batch batch);
  void update(Batch batch);
}
