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
  final bool rememberUser;
  final Exception? exception;

  const AuthStateLoggedOut({
    required super.isLoading,
    required this.rememberUser,
    required this.exception,
  });

  AuthStateLoggedOut copyWith({
    bool? isLoading,
    bool? rememberUser,
    Exception? exception,
  }) {
    return AuthStateLoggedOut(
      isLoading: isLoading ?? this.isLoading,
      rememberUser: rememberUser ?? this.rememberUser,
      exception: exception ?? this.exception,
    );
  }
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

  AuthStateRegistering copyWith({
    bool? isLoading,
    bool? isPasswordLongEnough,
    bool? isPasswordComplexEnough,
    Exception? exception,
  }) {
    return AuthStateRegistering(
      isLoading: isLoading ?? this.isLoading,
      isPasswordLongEnough: isPasswordLongEnough ?? this.isPasswordLongEnough,
      isPasswordComplexEnough:
          isPasswordComplexEnough ?? this.isPasswordComplexEnough,
      exception: exception ?? this.exception,
    );
  }
}

class AuthStateLoggedIn extends AuthState {
  final AppUser user;

  const AuthStateLoggedIn({required super.isLoading, required this.user});
}

class AuthStateForgotPassword extends AuthState {
  final bool sentEmail;
  final Exception? exception;

  const AuthStateForgotPassword({
    required super.isLoading,
    required this.sentEmail,
    required this.exception,
  });
}

class AuthStateVerifyEmail extends AuthState {
  final bool sentEmail;
  final Exception? exception;

  const AuthStateVerifyEmail({
    required super.isLoading,
    required this.sentEmail,
    required this.exception,
  });

  AuthStateVerifyEmail copyWith({
    bool? isLoading,
    bool? sentEmail,
    Exception? exception,
  }) {
    return AuthStateVerifyEmail(
      isLoading: isLoading ?? this.isLoading,
      sentEmail: sentEmail ?? this.sentEmail,
      exception: exception ?? this.exception,
    );
  }
}
