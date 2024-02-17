import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AppUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AppUser.fromFirebase(User user) {
    return AppUser(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
    );
  }
}
