import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventGoToRegister extends AuthEvent {
  const AuthEventGoToRegister();
}

class AuthEventGoToLogIn extends AuthEvent {
  const AuthEventGoToLogIn();
}

class AuthEventGoToForgotPassword extends AuthEvent {
  const AuthEventGoToForgotPassword();
}

class AuthEventGoToVerifyEmail extends AuthEvent {
  const AuthEventGoToVerifyEmail();
}

class AuthEventUpdateRegisteringState extends AuthEvent {
  final bool? showPassword;
  final bool? showRepeatPassword;

  const AuthEventUpdateRegisteringState({
    this.showPassword,
    this.showRepeatPassword,
  });
}

class AuthEventValidatePassword extends AuthEvent {
  final String password;

  const AuthEventValidatePassword({required this.password});
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String repeatPassword;

  const AuthEventRegister({
    required this.email,
    required this.password,
    required this.repeatPassword,
  });
}

class AuthEventUpdateLoggedOutState extends AuthEvent {
  final bool? rememberUser;
  final bool? showPassword;

  const AuthEventUpdateLoggedOutState({this.rememberUser, this.showPassword});
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  final bool rememberUser;

  const AuthEventLogIn({
    required this.email,
    required this.password,
    required this.rememberUser,
  });
}

class AuthEventAuthenticateWithBiometrics extends AuthEvent {
  const AuthEventAuthenticateWithBiometrics();
}

class AuthEventResetPassword extends AuthEvent {
  final String email;

  const AuthEventResetPassword({required this.email});
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
