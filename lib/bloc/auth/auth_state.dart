import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;

  const AuthStateLoggedOut({required this.exception});
}

class AuthStateRegistering extends AuthState {
  final bool? isPasswordLongEnough;
  final bool? isPasswordComplexEnough;
  final Exception? exception;

  const AuthStateRegistering({
    required this.isPasswordLongEnough,
    required this.isPasswordComplexEnough,
    required this.exception,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AppUser user;

  const AuthStateLoggedIn({required this.user});
}

class AuthStateVerifyEmail extends AuthState {
  const AuthStateVerifyEmail();
}
