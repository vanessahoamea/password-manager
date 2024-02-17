import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';
import 'package:password_manager/services/auth/providers/firebase_auth_provider.dart';

class AuthService {
  final AuthProvider authProvider;

  const AuthService(this.authProvider);

  factory AuthService.fromFirebase() => AuthService(FirebaseAuthProvider());

  Future<void> initialize() async => authProvider.initialize();

  AppUser? get user => authProvider.user;

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

  Future<void> sendPasswordResetEmail({required String email}) {
    return authProvider.sendPasswordResetEmail(email: email);
  }
}
