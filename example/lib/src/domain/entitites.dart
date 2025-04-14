import 'package:flutter/foundation.dart';

class Role {
  int? id;
  final String name;
  final String description;

  Role({this.id, required this.name, this.description = ''});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Role &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;

  Role copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

class User {
  final int? id;
  final String name;
  final String email;
  final List<Role> roles;

  User({this.id, required this.name, required this.email, required this.roles});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        listEquals(other.roles, roles);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ roles.hashCode;
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    List<Role>? roles,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
    );
  }
}

class UserRoles {
  final int? id;
  final int idRole;
  final int idUser;

  UserRoles({this.id, required this.idRole, required this.idUser});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRoles &&
        other.id == id &&
        other.idRole == idRole &&
        other.idUser == idUser;
  }

  @override
  int get hashCode => id.hashCode ^ idRole.hashCode ^ idUser.hashCode;
}
