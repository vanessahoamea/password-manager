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
  final Exception? exception;

  const ManagerStatePasswordsPage({
    required super.user,
    required this.passwords,
    required this.filteredPasswords,
    required this.exception,
  }) : super(title: 'My Passwords', navbarIndex: 0);

  ManagerStatePasswordsPage copyWith({
    AppUser? user,
    Stream<Iterable<Password>>? passwords,
    Iterable<Password>? filteredPasswords,
    Exception? exception,
  }) {
    return ManagerStatePasswordsPage(
      user: user ?? this.user,
      passwords: passwords ?? this.passwords,
      filteredPasswords: filteredPasswords,
      exception: exception,
    );
  }
}

class ManagerStateGeneratorPage extends ManagerState {
  const ManagerStateGeneratorPage({required super.user})
      : super(title: 'Generate Password', navbarIndex: 1);
}

class ManagerStateSettingsPage extends ManagerState {
  final bool supportsBiometrics;
  final bool hasBiometricsEnabled;

  const ManagerStateSettingsPage({
    required super.user,
    required this.supportsBiometrics,
    required this.hasBiometricsEnabled,
  }) : super(title: 'Settings', navbarIndex: 2);

  ManagerStateSettingsPage copyWith({
    AppUser? user,
    bool? supportsBiometrics,
    bool? hasBiometricsEnabled,
  }) {
    return ManagerStateSettingsPage(
      user: user ?? this.user,
      supportsBiometrics: supportsBiometrics ?? this.supportsBiometrics,
      hasBiometricsEnabled: hasBiometricsEnabled ?? this.hasBiometricsEnabled,
    );
  }
}

class ManagerStateSinglePasswordPage extends ManagerState {
  final Password? password;
  final String decryptedPassword;
  final ManagerState previousState;
  final bool showPassword;
  final bool isLoading;
  final Exception? exception;

  const ManagerStateSinglePasswordPage({
    required super.user,
    required this.password,
    required this.decryptedPassword,
    required this.previousState,
    required this.showPassword,
    required this.isLoading,
    required this.exception,
  });

  ManagerStateSinglePasswordPage copyWith({
    AppUser? user,
    Password? password,
    String? decryptedPassword,
    ManagerState? previousState,
    bool? showPassword,
    bool? isLoading,
    Exception? exception,
  }) {
    return ManagerStateSinglePasswordPage(
      user: user ?? this.user,
      password: password ?? this.password,
      decryptedPassword: decryptedPassword ?? this.decryptedPassword,
      previousState: previousState ?? this.previousState,
      showPassword: showPassword ?? this.showPassword,
      isLoading: isLoading ?? this.isLoading,
      exception: exception,
    );
  }
}
