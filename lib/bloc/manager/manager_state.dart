import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';

@immutable
abstract class ManagerState {
  final AppUser? user;

  const ManagerState({required this.user});
}

class ManagerStateUninitialized extends ManagerState {
  const ManagerStateUninitialized({super.user});
}

class ManagerStatePasswordsPage extends ManagerState {
  const ManagerStatePasswordsPage({required super.user});
}

class ManagerStateGeneratorPage extends ManagerState {
  const ManagerStateGeneratorPage({required super.user});
}

class ManagerStateSettingsPage extends ManagerState {
  const ManagerStateSettingsPage({required super.user});
}
