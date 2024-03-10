import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/passwords/password.dart';

@immutable
abstract class ManagerState {
  final AppUser? user;
  final String? title;
  final int? navbarIndex;
  final bool showToast;
  final String toastMessage;

  const ManagerState({
    required this.user,
    this.title,
    this.navbarIndex,
    this.showToast = false,
    this.toastMessage = 'Changes saved successfully.',
  });
}

class ManagerStateUninitialized extends ManagerState {
  const ManagerStateUninitialized({super.user});
}

class ManagerStatePasswordsPage extends ManagerState {
  final Stream<Iterable<Password>> passwords;
  final String? searchTerm;
  final Iterable<Password>? filteredPasswords;
  final Exception? exception;

  const ManagerStatePasswordsPage({
    required super.user,
    required super.showToast,
    super.toastMessage,
    required this.searchTerm,
    required this.passwords,
    required this.filteredPasswords,
    required this.exception,
  }) : super(title: 'My Passwords', navbarIndex: 0);

  ManagerStatePasswordsPage copyWith({
    AppUser? user,
    bool? showToast,
    String? toastMessage,
    Stream<Iterable<Password>>? passwords,
    String? searchTerm,
    Iterable<Password>? filteredPasswords,
    Exception? exception,
  }) {
    return ManagerStatePasswordsPage(
      user: user ?? this.user,
      showToast: showToast ?? this.showToast,
      toastMessage: toastMessage ?? this.toastMessage,
      passwords: passwords ?? this.passwords,
      searchTerm: searchTerm,
      filteredPasswords: filteredPasswords,
      exception: exception,
    );
  }
}

class ManagerStateGeneratorPage extends ManagerState {
  final String password;
  final int length;
  final bool includeLowercase;
  final bool includeUppercase;
  final bool includeNumbers;
  final bool includeSpecial;

  const ManagerStateGeneratorPage({
    required super.user,
    required this.password,
    required this.length,
    required this.includeLowercase,
    required this.includeUppercase,
    required this.includeNumbers,
    required this.includeSpecial,
  }) : super(title: 'Generate Password', navbarIndex: 1);

  ManagerStateGeneratorPage copyWith({
    AppUser? user,
    String? password,
    int? length,
    bool? includeLowercase,
    bool? includeUppercase,
    bool? includeNumbers,
    bool? includeSpecial,
  }) {
    return ManagerStateGeneratorPage(
      user: user ?? this.user,
      password: password ?? this.password,
      length: length ?? this.length,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSpecial: includeSpecial ?? this.includeSpecial,
    );
  }
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
  final bool showPassword;
  final bool isLoading;
  final String loadingMessage;
  final Exception? exception;

  const ManagerStateSinglePasswordPage({
    required super.user,
    required super.showToast,
    super.toastMessage,
    required this.password,
    required this.decryptedPassword,
    required this.showPassword,
    required this.isLoading,
    this.loadingMessage = 'Saving changes...',
    required this.exception,
  });

  ManagerStateSinglePasswordPage copyWith({
    AppUser? user,
    bool? showToast,
    String? toastMessage,
    Password? password,
    String? decryptedPassword,
    bool? showPassword,
    bool? isLoading,
    String? loadingMessage,
    Exception? exception,
  }) {
    return ManagerStateSinglePasswordPage(
      user: user ?? this.user,
      showToast: showToast ?? this.showToast,
      toastMessage: toastMessage ?? this.toastMessage,
      password: password ?? this.password,
      decryptedPassword: decryptedPassword ?? this.decryptedPassword,
      showPassword: showPassword ?? this.showPassword,
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      exception: exception,
    );
  }
}
