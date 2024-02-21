import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';

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
  const ManagerStatePasswordsPage({required super.user})
      : super(title: 'My Passwords', navbarIndex: 0);
}

class ManagerStateGeneratorPage extends ManagerState {
  const ManagerStateGeneratorPage({required super.user})
      : super(title: 'Generate Password', navbarIndex: 1);
}

class ManagerStateSettingsPage extends ManagerState {
  const ManagerStateSettingsPage({required super.user})
      : super(title: 'Settings', navbarIndex: 2);
}
