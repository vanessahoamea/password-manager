import 'package:password_manager/services/passwords/password.dart';

abstract class DatabaseProvider {
  Iterable<Password> get allPasswords;
  Future<void> createPassword({required Password password});
  Future<Password> getPassword({required String passwordId});
  Future<void> updatePassword({required Password password});
  Future<void> deletePassword({required String passwordId});
}
