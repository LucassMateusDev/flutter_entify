import 'package:example/data/database/app_db_context.dart';
import 'package:example/pages/role_list_page.dart';
import 'package:example/pages/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool isLoading = true;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _initialize() async {
    final dbContext = context.read<AppDbContext>();
    await dbContext.initialize();
    setState(() => isLoading = false);
  }

  void _updatePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView(
              controller: _pageController,
              onPageChanged: _updatePage,
              children: const [
                UserListPage(),
                RoleListPage(),
              ],
            ),
      bottomNavigationBar: Visibility(
        visible: !isLoading,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Roles'),
          ],
          onTap: (value) => _pageController.jumpToPage(value),
        ),
      ),
    );
  }
}
