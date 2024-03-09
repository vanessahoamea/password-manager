import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_exceptions.dart';
import 'package:password_manager/services/passwords/providers/database_provider.dart';
import 'package:password_manager/services/passwords/providers/firestore_database_provider.dart';

class PasswordService {
  final DatabaseProvider dbProvider;

  const PasswordService(this.dbProvider);

  factory PasswordService.fromFirestore() =>
      PasswordService(FirestoreDatabaseProvider());

  Stream<Iterable<Password>> allPasswords({required String userId}) {
    return dbProvider.allPasswords(userId: userId);
  }

  Future<void> createPassword({required Password password}) {
    return dbProvider.createPassword(password: password);
  }

  Future<Password> getPassword({required String passwordId}) {
    return dbProvider.getPassword(passwordId: passwordId);
  }

  Future<void> updatePassword({required Password password}) {
    return dbProvider.updatePassword(password: password);
  }

  Future<void> deletePassword({required String passwordId}) {
    return dbProvider.deletePassword(passwordId: passwordId);
  }

  Iterable<Password> filterPasswords({
    required Iterable<Password> passwords,
    required String term,
  }) {
    return passwords.where((password) =>
        password.website.toLowerCase().contains(term.toLowerCase()) ||
        (password.username != null &&
            password.username!.toLowerCase().contains(term.toLowerCase())));
  }

  static Future<List<dynamic>> generateKey({
    required String masterPassword,
    required List<int> salt,
  }) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000,
      bits: 256,
    );
    final key = await algorithm.deriveKeyFromPassword(
      password: masterPassword,
      nonce: salt,
    );
    final iv = IV.fromLength(16);

    return [key, iv];
  }

  static Future<String> encrypt({
    required String plaintextPassword,
    required List<int> encryptionKey,
    required IV iv,
  }) async {
    try {
      final key = Key(Uint8List.fromList(encryptionKey));
      final encrypter = Encrypter(AES(key));

      return encrypter.encrypt(plaintextPassword, iv: iv).base64;
    } on Exception catch (_) {
      throw PasswordExceptionInvalidKey();
    }
  }

  static Future<String> decrypt({
    required String encryptedPassword,
    required List<int> encryptionKey,
    required IV iv,
  }) async {
    try {
      final key = Key(Uint8List.fromList(encryptionKey));
      final encrypter = Encrypter(AES(key));

      return encrypter.decrypt(Encrypted.fromBase64(encryptedPassword), iv: iv);
    } on Exception catch (_) {
      throw PasswordExceptionInvalidKey();
    }
  }
}
