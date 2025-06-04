import 'package:example/src/data/database/app_db_context.dart';
import 'package:example/src/data/repositories/role_repository.dart';
import 'package:example/src/data/repositories/user_repository.dart';
import 'package:example/src/ui/pages/splash_page.dart';
import 'package:example/src/ui/theme/example_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ExampleAppTheme.lightTheme,
        home: SplashPage(),
      ),
    );
  }
}
