import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;

  const AuthState({required this.isLoading});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;

  const AuthStateLoggedOut({required super.isLoading, required this.exception});
}

class AuthStateRegistering extends AuthState {
  final bool? isPasswordLongEnough;
  final bool? isPasswordComplexEnough;
  final Exception? exception;

  const AuthStateRegistering({
    required super.isLoading,
    required this.isPasswordLongEnough,
    required this.isPasswordComplexEnough,
    required this.exception,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AppUser user;

  const AuthStateLoggedIn({required super.isLoading, required this.user});
}

class AuthStateVerifyEmail extends AuthState {
  final bool sentEmail;
  final Exception? exception;

  const AuthStateVerifyEmail({
    required super.isLoading,
    required this.sentEmail,
    required this.exception,
  });
}
