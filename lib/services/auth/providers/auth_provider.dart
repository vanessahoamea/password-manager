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
}
