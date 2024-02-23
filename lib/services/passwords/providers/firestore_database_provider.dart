import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/providers/database_provider.dart';

class FirestoreDatabaseProvider extends DatabaseProvider {
  static final FirestoreDatabaseProvider _instance =
      FirestoreDatabaseProvider._internal();

  factory FirestoreDatabaseProvider() {
    return _instance;
  }

  FirestoreDatabaseProvider._internal();

  @override
  // TODO: implement allPasswords
  Iterable<Password> get allPasswords => throw UnimplementedError();

  @override
  Future<void> createPassword({required Password password}) {
    // TODO: implement createPassword
    throw UnimplementedError();
  }

  @override
  Future<void> deletePassword({required String passwordId}) {
    // TODO: implement deletePassword
    throw UnimplementedError();
  }

  @override
  Future<Password> getPassword({required String passwordId}) {
    // TODO: implement getPassword
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword({required Password password}) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
