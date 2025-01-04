// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

abstract interface class IConnection {
  Future<Database> openConnection();
  void closeConnection();
}
