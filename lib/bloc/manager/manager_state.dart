import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/passwords/password.dart';

@immutable
abstract class ManagerState {
  final AppUser? user;
  final String? title;
  final int? navbarIndex;

  const ManagerState({required this.user, this.title, this.navbarIndex});
}

class ManagerStateUninitialized extends ManagerState {
  const ManagerStateUninitialized({super.user});
}

class ManagerStatePasswordsPage extends ManagerState {
  final Stream<Iterable<Password>> passwords;
  final Iterable<Password>? filteredPasswords;

  const ManagerStatePasswordsPage({
    required super.user,
    required this.passwords,
    this.filteredPasswords,
  }) : super(title: 'My Passwords', navbarIndex: 0);

  ManagerStatePasswordsPage copyWith({Iterable<Password>? filteredPasswords}) {
    return ManagerStatePasswordsPage(
      user: user,
      passwords: passwords,
      filteredPasswords: filteredPasswords,
    );
  }
}

class ManagerStateGeneratorPage extends ManagerState {
  const ManagerStateGeneratorPage({required super.user})
      : super(title: 'Generate Password', navbarIndex: 1);
}

class ManagerStateSettingsPage extends ManagerState {
  const ManagerStateSettingsPage({required super.user})
      : super(title: 'Settings', navbarIndex: 2);
}
