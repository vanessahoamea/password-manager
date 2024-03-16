import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/services/passwords/password_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late final FlutterSecureStorage storage;
  late final SharedPreferences preferences;

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  Future<void> initialize() async {
    storage = const FlutterSecureStorage();
    preferences = await SharedPreferences.getInstance();
  }

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

  Future<List<int>> getEncryptionKey() async {
    final encodedKey = await storage.read(key: 'encryption_key');
    List<int> keyBytes = jsonDecode(encodedKey ?? '[]').cast<int>();

    return keyBytes;
  }

  Future<void> createEncryptionKey({
    required String masterPassword,
    required List<int> salt,
  }) async {
    final keyBytes = await PasswordService.generateKey(
      masterPassword: masterPassword,
      salt: salt,
    );
    await storage.write(key: 'encryption_key', value: jsonEncode(keyBytes));
  }

  Future<void> deleteEncryptionKey() async {
    await storage.delete(key: 'encryption_key');
  }

  Map<String, dynamic> getPasswordSettings() {
    String encodedMap = preferences.getString('password_settings') ?? '{}';
    Map<String, dynamic> map = jsonDecode(encodedMap);

    map['length'] = map['length'] ?? 16;
    map['includeLowercase'] = map['includeLowercase'] ?? true;
    map['includeUppercase'] = map['includeUppercase'] ?? true;
    map['includeNumbers'] = map['includeNumbers'] ?? true;
    map['includeSpecial'] = map['includeSpecial'] ?? true;

    return map;
  }

  Future<void> setPasswordSettings(Map<String, dynamic> map) async {
    await preferences.setString('password_settings', jsonEncode(map));
  }

  ThemeMode getThemeMode() {
    String theme = preferences.getString('theme') ?? 'system';
    if (theme == 'light') {
      return ThemeMode.light;
    } else if (theme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await preferences.setString('theme', themeMode.name);
  }

  bool getHasBiometricsEnabled() {
    bool value = preferences.getBool('has_biometrics_enabled') ?? false;
    return value;
  }

  Future<void> toggleBiometrics(bool hasBiometricsEnabled) async {
    await preferences.setBool('has_biometrics_enabled', hasBiometricsEnabled);
  }
}
