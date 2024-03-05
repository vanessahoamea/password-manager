import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';

import '../exceptions.dart';

class MockAuthProvider implements AuthProvider {
  AppUser? _user;
  bool _isInitialized = false;

  MockAuthProvider();

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  AppUser get user {
    final user = _user;
    if (user != null) {
      return user;
    } else {
      throw AuthExceptionUserNotLoggedIn();
    }
  }

  bool get isInitialized => _isInitialized;

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    final isPasswordLongEnough = AuthService.validatePasswordLength(password);
    final isPasswordComplexEnough =
        AuthService.validatePasswordComplexity(password);

    if (email.isEmpty ||
        repeatPassword.isEmpty ||
        isPasswordLongEnough == null ||
        isPasswordComplexEnough == null) {
      throw AuthExceptionEmptyFields();
    }

    if (!isPasswordLongEnough || !isPasswordComplexEnough) {
      throw AuthExceptionWeakPassword();
    }

    if (password != repeatPassword) {
      throw AuthExceptionPasswordsDontMatch();
    }

    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  Future<AppUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    if (email == 'bad@address.com' || password == 'Badpassword.789') {
      throw AuthExceptionInvalidCredentials();
    }

    await Future.delayed(const Duration(seconds: 1));

    _user = AppUser(id: 'dummy', email: email, isEmailVerified: false);
    return Future.value(_user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    if (_user == null) {
      throw AuthExceptionUserNotLoggedIn();
    }

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    if (_user == null) {
      throw AuthExceptionUserNotLoggedIn();
    }

    await Future.delayed(const Duration(seconds: 1));
    _user = AppUser(id: 'dummy', email: _user!.email, isEmailVerified: true);
  }
}
