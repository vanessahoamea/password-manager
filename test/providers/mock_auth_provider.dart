import 'dart:math';

import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';

import '../exceptions.dart';

class MockAuthProvider implements AuthProvider {
  AppUser? _user;
  List<int>? _userSalt;
  bool _isInitialized = false;
  int _emailSentTimestamp = 0;

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

  List<int>? get userSalt => _userSalt;

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

    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - _emailSentTimestamp <= 1000 * 60) {
      throw AuthExceptionEmailLimitExceeded();
    }

    await Future.delayed(const Duration(seconds: 1));
    _user = AppUser(id: 'dummy', email: _user!.email, isEmailVerified: true);
    _emailSentTimestamp = currentTimestamp;
  }

  @override
  Future<void> createUserSalt() async {
    List<int> salt = [];
    for (int i = 1; i <= 32; i++) {
      salt.add(Random().nextInt(256));
    }

    _userSalt = salt;
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<int>> getUserSalt() async {
    if (_user == null) {
      throw AuthExceptionUserNotLoggedIn();
    }

    if (_userSalt == null) {
      throw AuthExceptionGeneric();
    }

    await Future.delayed(const Duration(seconds: 1));
    return _userSalt!;
  }
}
