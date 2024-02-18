import 'package:flutter/material.dart';
import 'package:password_manager/services/auth/app_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingMessage;

  const AuthState({
    required this.isLoading,
    this.loadingMessage = 'Loading...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState {
  final bool rememberUser;
  final Exception? exception;

  const AuthStateLoggedOut({
    required super.isLoading,
    super.loadingMessage,
    required this.rememberUser,
    required this.exception,
  });

  AuthStateLoggedOut copyWith({
    bool? isLoading,
    String? loadingMessage,
    bool? rememberUser,
    Exception? exception,
  }) {
    return AuthStateLoggedOut(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      rememberUser: rememberUser ?? this.rememberUser,
      exception: exception,
    );
  }
}

class AuthStateRegistering extends AuthState {
  final bool? isPasswordLongEnough;
  final bool? isPasswordComplexEnough;
  final Exception? exception;

  const AuthStateRegistering({
    required super.isLoading,
    super.loadingMessage,
    required this.isPasswordLongEnough,
    required this.isPasswordComplexEnough,
    required this.exception,
  });

  AuthStateRegistering copyWith({
    bool? isLoading,
    String? loadingMessage,
    bool? isPasswordLongEnough,
    bool? isPasswordComplexEnough,
    Exception? exception,
  }) {
    return AuthStateRegistering(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      isPasswordLongEnough: isPasswordLongEnough ?? this.isPasswordLongEnough,
      isPasswordComplexEnough:
          isPasswordComplexEnough ?? this.isPasswordComplexEnough,
      exception: exception,
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
    super.loadingMessage,
    required this.sentEmail,
    required this.exception,
  });
}

class AuthStateVerifyEmail extends AuthState {
  final bool sentEmail;
  final Exception? exception;

  const AuthStateVerifyEmail({
    required super.isLoading,
    super.loadingMessage,
    required this.sentEmail,
    required this.exception,
  });

  AuthStateVerifyEmail copyWith({
    bool? isLoading,
    String? loadingMessage,
    bool? sentEmail,
    Exception? exception,
  }) {
    return AuthStateVerifyEmail(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      sentEmail: sentEmail ?? this.sentEmail,
      exception: exception ?? this.exception,
    );
  }
}
