import 'package:example/data/database/app_db_context.dart';
import 'package:example/pages/example_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/role_repository.dart';
import 'data/repositories/user_repository.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDbContext>(
          create: (_) => AppDbContext(),
        ),
        Provider<UserRepository>(
          create: (context) => UserRepository(
            dbContext: context.read<AppDbContext>(),
          ),
        ),
        Provider<RoleRepository>(
          create: (context) => RoleRepository(
            dbContext: context.read<AppDbContext>(),
          ),
        ),
      ],
      child: const MaterialApp(
        home: ExamplePage(),
      ),
    );
  }
}
