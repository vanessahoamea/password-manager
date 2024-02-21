import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';

@immutable
abstract class ManagerEvent {
  const ManagerEvent();
}

class ManagerEventInitialize extends ManagerEvent {
  final AppUser user;

  const ManagerEventInitialize({required this.user});
}

class ManagerEventGoToPasswordsPage extends ManagerEvent {
  const ManagerEventGoToPasswordsPage();
}

class ManagerEventGoToGeneratorPage extends ManagerEvent {
  const ManagerEventGoToGeneratorPage();
}

class ManagerEventGoToSettingsPage extends ManagerEvent {
  const ManagerEventGoToSettingsPage();
}
