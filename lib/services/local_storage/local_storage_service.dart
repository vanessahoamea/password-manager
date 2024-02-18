import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  const LocalStorageService();

  Future<bool> getRememberUser() async {
    String value = await storage.read(key: 'remember_user') ?? 'false';
    return value == 'true';
  }

  Future<void> rememberUser({
    required String email,
    required String password,
  }) async {
    await storage.write(key: 'remember_user', value: 'true');
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  Future<void> forgetUser() async {
    await storage.write(key: 'remember_user', value: 'false');
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
  }

  Future<Map<String, String>> getCredentials() async {
    Map<String, String> credentials = {};

    credentials['email'] = await storage.read(key: 'email') ?? '';
    credentials['password'] = await storage.read(key: 'password') ?? '';

    return credentials;
  }
}
