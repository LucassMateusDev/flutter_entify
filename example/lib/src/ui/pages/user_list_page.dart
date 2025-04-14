import 'package:example/src/data/repositories/role_repository.dart';
import 'package:example/src/data/repositories/user_repository.dart';
import 'package:example/src/domain/entitites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> users = [];
  final List<Role> roles = [];
  late final UserRepository userRepository;
  late final RoleRepository roleRepository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userRepository = context.read<UserRepository>();
      roleRepository = context.read<RoleRepository>();
      initialize();
    });
  }

  void initialize() async {
    users.addAll(await userRepository.getAll());
    roles.addAll(await roleRepository.getAll());
    setState(() {});
  }

  Future<void> _openCreateUserDialog() async {
    final TextEditingController nameEC = TextEditingController();
    final TextEditingController emailEC = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create New User',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameEC,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailEC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                if (nameEC.text.isNotEmpty) {
                  var newUser = User(
                    name: nameEC.text,
                    email: emailEC.text,
                    roles: [],
                  );
                  final id = await userRepository.insert(newUser);
                  newUser = newUser.copyWith(id: id);
                  users.add(newUser);

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

  void _openEditUserDialog(User user) {
    final nameEC = TextEditingController(text: user.name);
    final emailEC = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Edit User ${user.id}'),
              IconButton(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  await userRepository.delete(user);
                  setState(() {
                    users.removeWhere((e) => e == user);
                  });
                  nav.pop();
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameEC,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailEC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                final updatedUser = user.copyWith(
                  name: nameEC.text,
                  email: emailEC.text,
                );
                await userRepository.update(updatedUser);
                setState(() {});
                nav.pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Users',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 125,
                      child: FilledButton.icon(
                        onPressed: _openCreateUserDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Add User'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('${user.id} - ${user.name}'),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            onPressed: () => _openEditUserDialog(user),
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
