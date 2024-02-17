import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/firebase_options.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';
import 'package:password_manager/services/auth/app_user.dart';

class FirebaseAuthProvider extends AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AppUser? get user {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? AppUser.fromFirebase(user) : null;
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    try {
      final isPasswordLongEnough = validatePasswordLength(password);
      final isPasswordComplexEnough = validatePasswordComplexity(password);

      if (email.isEmpty ||
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

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = this.user;
      if (user != null) {
        return user;
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionInvalidEmail();
        case 'email-already-in-use':
          throw AuthExceptionEmailAlreadyInUse();
        default:
          throw AuthExceptionGeneric();
      }
    } catch (e) {
      throw AuthExceptionGeneric();
    }
  }

  @override
  Future<AppUser> logIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthExceptionEmptyFields();
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = this.user;
      if (user != null) {
        return user;
      } else {
        throw AuthExceptionUserNotLoggedIn();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionInvalidEmail();
        case 'user-not-found':
          throw AuthExceptionUserNotFound();
        case 'wrong-password':
          throw AuthExceptionWrongPassword();
        default:
          throw AuthExceptionGeneric();
      }
    } catch (_) {
      throw AuthExceptionGeneric();
    }
  }

  @override
  Future<void> logOut() async {
    final user = this.user;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw AuthExceptionLogOut();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (_) {
      throw Exception();
    } catch (_) {
      throw Exception();
    }
  }

  @override
  bool? validatePasswordLength(String password) {
    if (password.isEmpty) {
      return null;
    }
    return password.length >= 8;
  }

  @override
  bool? validatePasswordComplexity(String password) {
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
