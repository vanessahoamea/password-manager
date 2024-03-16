import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';
import 'package:password_manager/services/auth/providers/firebase_auth_provider.dart';

class AuthService {
  final AuthProvider authProvider;

  const AuthService(this.authProvider);

  factory AuthService.fromFirebase() => AuthService(FirebaseAuthProvider());

  Future<void> initialize() async => authProvider.initialize();

  AppUser get user => authProvider.user;

  Future<AppUser> register({
    required String email,
    required String password,
    required String repeatPassword,
  }) {
    return authProvider.register(
      email: email,
      password: password,
      repeatPassword: repeatPassword,
    );
  }

  Future<AppUser> logIn({required String email, required String password}) {
    return authProvider.logIn(email: email, password: password);
  }

  Future<void> logOut() => authProvider.logOut();

  Future<void> sendEmailVerification() => authProvider.sendEmailVerification();

  Future<void> createUserSalt() => authProvider.createUserSalt();

  Future<List<int>> getUserSalt() => authProvider.getUserSalt();

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
