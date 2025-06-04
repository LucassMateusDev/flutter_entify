import 'package:example/src/data/repositories/role_repository.dart';
import 'package:example/src/data/repositories/user_repository.dart';
import 'package:example/src/domain/entitites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleListPage extends StatefulWidget {
  const RoleListPage({super.key});

  @override
  State<RoleListPage> createState() => _RoleListPageState();
}

class _RoleListPageState extends State<RoleListPage> {
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

  void _openUserSelectionDialog(Role role) {
    final tempUsers = users
        .map((user) => user.copyWith(roles: List.from(user.roles)))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Assign Users to ${role.name}'),
            content: SingleChildScrollView(
              child: Column(
                children: tempUsers.map((user) {
                  var isSelected = user.roles.contains(role);

                  return CheckboxListTile(
                    title: Text('${user.id} - ${user.name}'),
                    value: isSelected,
                    onChanged: (bool? value) {
                      if (value == null) return;
                      setState(() {
                        isSelected = value;
                        if (isSelected) {
                          user.roles.add(role);
                        } else {
                          user.roles.remove(role);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  for (int i = 0; i < users.length; i++) {
                    users[i] = tempUsers[i];
                    await userRepository.update(users[i]);
                  }
                  setState(() {});
                  nav.pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  void _openCreateRoleDialog() {
    final nameEC = TextEditingController();
    final descriptionEC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Role'),
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
                controller: descriptionEC,
                decoration: const InputDecoration(
                  labelText: 'Description',
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

                if (nameEC.text.isNotEmpty) {
                  final newRole = Role(
                    name: nameEC.text,
                    description: descriptionEC.text,
                  );
                  final id = await roleRepository.insert(newRole);
                  newRole.id = id;
                  roles.add(newRole);
                  setState(() {});
                }

                nav.pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _openEditRoleDialog(Role role) {
    final nameEC = TextEditingController(text: role.name);
    final descriptionEC = TextEditingController(text: role.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Edit Role - ${role.id}'),
            IconButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                await roleRepository.delete(role);
                setState(() {
                  roles.removeWhere((e) => e == role);
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
              controller: descriptionEC,
              decoration: const InputDecoration(
                labelText: 'Description',
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
              if (nameEC.text.isNotEmpty) {
                final updateRole = role.copyWith(
                  name: nameEC.text,
                  description: descriptionEC.text,
                );
                await roleRepository.update(updateRole);
                setState(() {});
              }
              nav.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
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
                    const Text(
                      'Roles',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 125,
                      child: FilledButton.icon(
                        onPressed: _openCreateRoleDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Role'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(role.name),
                          subtitle: Text('ID: ${role.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit Role',
                                onPressed: () => _openEditRoleDialog(role),
                              ),
                              OutlinedButton(
                                onPressed: () => _openUserSelectionDialog(role),
                                child: const Text('Assign Users'),
                              ),
                            ],
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
