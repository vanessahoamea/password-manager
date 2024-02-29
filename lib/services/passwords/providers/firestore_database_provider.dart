import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_exceptions.dart';
import 'package:password_manager/services/passwords/providers/database_provider.dart';

class FirestoreDatabaseProvider extends DatabaseProvider {
  final passwords = FirebaseFirestore.instance.collection('passwords');
  static final FirestoreDatabaseProvider _instance =
      FirestoreDatabaseProvider._internal();

  factory FirestoreDatabaseProvider() {
    return _instance;
  }

  FirestoreDatabaseProvider._internal();

  @override
  Stream<Iterable<Password>> allPasswords({required String userId}) {
    try {
      return passwords
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((event) => event.docs.map((doc) => Password.fromFirestore(doc)));
    } catch (_) {
      throw PasswordExceptionFailedToGetAll();
    }
  }

  @override
  Future<void> createPassword({required Password password}) async {
    try {
      await passwords.add(password.toMap());
    } catch (_) {
      throw PasswordExceptionFailedToCreate();
    }
  }

  @override
  Future<Password> getPassword({required String passwordId}) async {
    try {
      final password = await passwords.doc(passwordId).get();
      return Password.fromFirestore(password);
    } catch (_) {
      throw PasswordExceptionFailedToGetOne();
    }
  }

  @override
  Future<void> updatePassword({required Password password}) async {
    try {
      await passwords.doc(password.id).update(password.toMap());
    } catch (_) {
      throw PasswordExceptionFailedToUpdate();
    }
  }

  @override
  Future<void> deletePassword({required String passwordId}) async {
    try {
      await passwords.doc(passwordId).delete();
    } catch (_) {
      throw PasswordExceptionFailedToDelete();
    }
  }
}
