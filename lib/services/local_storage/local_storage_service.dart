import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/services/passwords/password_service.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  Future<bool> getRememberUser() async {
    String value = await storage.read(key: 'remember_user') ?? 'false';
    return value == 'true';
  }

  Future<void> rememberUser({
    required String email,
    required String password,
  }) async {
    await Future.wait([
      storage.write(key: 'remember_user', value: 'true'),
      storage.write(key: 'email', value: email),
      storage.write(key: 'password', value: password)
    ]);
  }

  Future<void> forgetUser() async {
    await Future.wait([
      storage.write(key: 'remember_user', value: 'false'),
      storage.delete(key: 'email'),
      storage.delete(key: 'password')
    ]);
  }

  Future<Map<String, String>> getCredentials() async {
    Map<String, String> credentials = {};

    credentials['email'] = await storage.read(key: 'email') ?? '';
    credentials['password'] = await storage.read(key: 'password') ?? '';

    return credentials;
  }

  Future<List<dynamic>> getEncryptionKey() async {
    final [encodedIV, encodedKey] = await Future.wait([
      storage.read(key: 'iv'),
      storage.read(key: 'encryption_key'),
    ]);
    List<int> key = jsonDecode(encodedKey ?? '[]').cast<int>();
    IV iv = IV.fromBase64(encodedIV ?? '');

    return [key, iv];
  }

  Future<void> createEncryptionKey({required String masterPassword}) async {
    List<int> salt = [];
    for (int i = 1; i <= 32; i++) {
      salt.add(Random().nextInt(256));
    }

    final [key, iv] = await PasswordService.generateKey(
      masterPassword: masterPassword,
      salt: salt,
    );
    List<int> keyBytes = await key.extractBytes();

    await Future.wait([
      storage.write(key: 'iv', value: iv.base64),
      storage.write(key: 'encryption_key', value: jsonEncode(keyBytes)),
    ]);
  }
}
