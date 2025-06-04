import 'package:example/src/data/database/app_db_context.dart';
import 'package:example/src/ui/pages/role_list_page.dart';
import 'package:example/src/ui/pages/user_list_page.dart';
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
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Example',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
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
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security_outlined),
              label: 'Roles',
            ),
          ],
          onTap: (value) => _pageController.jumpToPage(value),
        ),
      ),
    );
  }
}
