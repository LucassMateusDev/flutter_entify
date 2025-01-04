import 'package:flutter/material.dart';
import 'sqlite_connection_factory.dart';

class SqliteAdmConnection with WidgetsBindingObserver {
  late final SqliteConnectionFactory connection;
  static SqliteAdmConnection? _instance;

  static SqliteAdmConnection get i {
    if (_instance == null) {
      throw Exception(
          'SqliteAdmConnection não foi inicializado. Chame SqliteAdmConnection.initialize().');
    }
    return _instance!;
  }

  SqliteAdmConnection._({required this.connection});

  static void initialize(SqliteConnectionFactory connection) {
    _instance ??= SqliteAdmConnection._(connection: connection);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        connection.closeConnection();
        break;
    }

    super.didChangeAppLifecycleState(state);
  }
}
