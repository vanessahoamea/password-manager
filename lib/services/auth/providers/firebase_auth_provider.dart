import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/firebase_options.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';
import 'package:password_manager/services/auth/app_user.dart';

class FirebaseAuthProvider extends AuthProvider {
  static final FirebaseAuthProvider _instance =
      FirebaseAuthProvider._internal();
  static int emailSentTimestamp = 0;

  factory FirebaseAuthProvider() {
    return _instance;
  }

  FirebaseAuthProvider._internal();

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
  Future<void> sendEmailVerification({bool updateTimestamp = true}) async {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimestamp - emailSentTimestamp <= 1000 * 60) {
      throw AuthExceptionEmailLimitExceeded();
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
        emailSentTimestamp =
            updateTimestamp ? currentTimestamp : emailSentTimestamp;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'too-many-requests':
            throw AuthExceptionEmailLimitExceeded();
          default:
            throw AuthExceptionGeneric();
        }
      }
    } else {
      throw AuthExceptionUserNotLoggedIn();
    }
  }

  @override
  Future<void> createUserSalt() async {
    List<int> salt = [];
    for (int i = 1; i <= 32; i++) {
      salt.add(Random().nextInt(256));
    }

    try {
      FirebaseFirestore.instance
          .collection('salts')
          .add({'userId': user.id, 'nonce': jsonEncode(salt)});
    } on AuthExceptionUserNotLoggedIn catch (_) {
      rethrow;
    } on Exception catch (_) {
      throw AuthExceptionGeneric();
    }
  }

  @override
  Future<List<int>> getUserSalt() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('salts')
          .where('userId', isEqualTo: user.id)
          .get();
      final data = snapshot.docs.first.data();

      return jsonDecode(data['nonce'] ?? '[]').cast<int>();
    } on AuthExceptionUserNotLoggedIn catch (_) {
      rethrow;
    } on Exception catch (_) {
      throw AuthExceptionGeneric();
    }
  }
}
