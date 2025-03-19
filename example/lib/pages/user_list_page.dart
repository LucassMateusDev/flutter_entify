import 'package:example/data/repositories/user_repository.dart';
import 'package:example/domain/entitites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final UserRepository userRepository;
  final List<User> users = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userRepository = context.read<UserRepository>();
      _initialize();
    });
  }

  void _initialize() async {
    users.addAll(await userRepository.getAll());
    setState(() {});
  }

  void _openCreateUserDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    void disposeControllers() {
      nameController.dispose();
      emailController.dispose();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                if (nameController.text.isNotEmpty) {
                  final newUser = User(
                    name: nameController.text,
                    email: emailController.text,
                    roles: [],
                  );
                  await userRepository.insert(newUser);
                  users.add(newUser);

                  disposeControllers();
                  setState(() {});

                  nav.pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _openCreateUserDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Add User'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: users.map((user) {
                return ExpansionTile(
                  title: Text('${user.name} - ${user.email}'),
                  subtitle: Text(user.id?.toString() ?? ''),
                  children: user.roles
                      .map((role) => ListTile(
                            title: Text(role.name),
                            leading: const Icon(Icons.security),
                          ))
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
