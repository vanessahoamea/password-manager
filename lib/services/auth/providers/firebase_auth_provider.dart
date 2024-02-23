import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/firebase_options.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/services/auth/auth_service.dart';
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
  AppUser get user {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AppUser.fromFirebase(user);
    } else {
      throw AuthExceptionUserNotLoggedIn();
    }
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    try {
      final isPasswordLongEnough = AuthService.validatePasswordLength(password);
      final isPasswordComplexEnough =
          AuthService.validatePasswordComplexity(password);

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

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionInvalidEmail();
        case 'email-already-in-use':
          throw AuthExceptionEmailAlreadyInUse();
        default:
          throw AuthExceptionGeneric();
      }
    } catch (_) {
      rethrow;
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

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionInvalidEmail();
        case 'invalid-credential':
          throw AuthExceptionInvalidCredentials();
        default:
          throw AuthExceptionGeneric();
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      user; // checking if it's not null
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw AuthExceptionUserNotLoggedIn();
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      if (email.isEmpty) {
        throw AuthExceptionEmptyFields();
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionInvalidEmail();
        default:
          throw AuthExceptionGeneric();
      }
    } catch (_) {
      rethrow;
    }
  }
}
