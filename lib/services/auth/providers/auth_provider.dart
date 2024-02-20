import 'package:password_manager/services/auth/app_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AppUser get user;
  Future<AppUser> register({
    required String email,
    required String password,
    required String repeatPassword,
  });
  Future<AppUser> logIn({required String email, required String password});
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail({required String email});

  static bool? validatePasswordLength(String password) {
    if (password.isEmpty) {
      return null;
    }
    return password.length >= 8;
  }

  static bool? validatePasswordComplexity(String password) {
    if (password.isEmpty) {
      return null;
    }
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasNumbers && hasSpecialCharacters;
  }
}
