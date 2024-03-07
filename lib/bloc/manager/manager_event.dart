import 'package:flutter/material.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/passwords/password.dart';

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

class ManagerEventGoToSinglePassword extends ManagerEvent {
  final Password? password;

  const ManagerEventGoToSinglePassword({required this.password});
}

class ManagerEventReturnToPreviousState extends ManagerEvent {
  final ManagerState previousState;

  const ManagerEventReturnToPreviousState({required this.previousState});
}

class ManagerEventFilterPasswords extends ManagerEvent {
  final String term;
  final Iterable<Password> passwords;

  const ManagerEventFilterPasswords({
    required this.term,
    required this.passwords,
  });
}

class ManagerEventToggleBiometrics extends ManagerEvent {
  const ManagerEventToggleBiometrics();
}
