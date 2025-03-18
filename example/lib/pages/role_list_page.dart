import 'package:example/data/repositories/role_repository.dart';
import 'package:example/data/repositories/user_repository.dart';
import 'package:example/domain/entitites.dart';
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
    showDialog(
      context: context,
      builder: (context) {
        final selectedUsers = <User>{};

        return AlertDialog(
          title: Text('Assign Users to ${role.name}'),
          content: SingleChildScrollView(
            child: Column(
              children: users.map((user) {
                final isSelected = user.roles.contains(role);

                return CheckboxListTile(
                  title: Text(user.name),
                  value: isSelected || selectedUsers.contains(user),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedUsers.add(user);
                      } else {
                        selectedUsers.remove(user);
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
            ElevatedButton(
              onPressed: () async {
                // await roleRepository.update(role);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openCreateRoleDialog() {
    final TextEditingController roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Role'),
          content: TextField(
            controller: roleController,
            decoration: const InputDecoration(hintText: 'Enter role name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (roleController.text.isNotEmpty) {
                  final newRole = Role(name: roleController.text);
                  // await roleRepository.insert(newRole); // Salva no banco
                  roles.add(newRole); // Atualiza a lista local
                  setState(() {});
                }
                Navigator.pop(context);
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Roles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _openCreateRoleDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Role'),
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
                  child: ListTile(
                    title: Text(role.name),
                    trailing: ElevatedButton(
                      onPressed: () => _openUserSelectionDialog(role),
                      child: const Text('Assign Users'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
