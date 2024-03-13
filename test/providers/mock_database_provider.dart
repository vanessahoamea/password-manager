import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_exceptions.dart';
import 'package:password_manager/services/passwords/password_service.dart';
import 'package:password_manager/services/passwords/providers/database_provider.dart';

import '../exceptions.dart';

class MockDatabaseProvider implements DatabaseProvider {
  final PasswordsStream _passwords = PasswordsStream();
  late final AppUser _user = const AppUser(
    id: 'dummy',
    email: 'test@email.com',
    isEmailVerified: true,
  );
  late final StreamSubscription _subscription;
  late final List<int> _encryptionKey;
  late final IV _iv;
  bool _isInitialized = false;
  Iterable<Password>? _currentPasswords;

  MockDatabaseProvider();

  Future<void> initialize() async {
    final [key, iv] = await PasswordService.generateKey(
      masterPassword: 'Testpassword.123',
      salt: [1, 2, 3, 4, 5],
    );
    _encryptionKey = await key.extractBytes();
    _iv = iv;
    _subscription =
        _passwords.listen((passwords) => _currentPasswords = passwords);

    _passwords.add([
      Password(
        id: 'first_dummy',
        userId: _user.id,
        website: 'Google',
        encryptedPassword: 'MyGooglePassword.456',
      ),
      Password(
        id: 'second_dummy',
        userId: _user.id,
        website: 'Facebook',
        encryptedPassword: 'MyFacebookPassword.789',
      )
    ]);

    _isInitialized = true;
  }

  AppUser get user => _user;
  List<int> get encryptionKey => _encryptionKey;
  IV get iv => _iv;
  bool get isInitialized => _isInitialized;
  Iterable<Password>? get currentPasswords => _currentPasswords;

  @override
  Stream<Iterable<Password>> allPasswords({required String userId}) {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    return _passwords;
  }

  @override
  Future<void> createPassword({required Password password}) async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    if (password.website.isEmpty || password.encryptedPassword.isEmpty) {
      throw PasswordExceptionEmptyFields();
    }

    _passwords.add(currentPasswords!.toList()..add(password));
  }

  @override
  Future<Password> getPassword({required String passwordId}) async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    try {
      return currentPasswords!
          .firstWhere((password) => password.id == passwordId);
    } catch (_) {
      throw PasswordExceptionFailedToGetOne();
    }
  }

  @override
  Future<void> updatePassword({required Password password}) async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    if (password.website.isEmpty || password.encryptedPassword.isEmpty) {
      throw PasswordExceptionEmptyFields();
    }

    List<Password> passwordsList = currentPasswords!.toList();
    for (int i = 0; i < passwordsList.length; i++) {
      if (passwordsList[i].id == password.id) {
        passwordsList[i] = Password(
          id: password.id,
          userId: password.userId,
          website: password.website,
          username: password.username,
          encryptedPassword: password.encryptedPassword,
        );
        _passwords.add(passwordsList);
        return;
      }
    }

    throw PasswordExceptionFailedToUpdate();
  }

  @override
  Future<void> deletePassword({required String passwordId}) async {
    if (!isInitialized) {
      throw AuthExceptionNotInitialized();
    }

    List<Password> passwordsList = currentPasswords!.toList();
    for (int i = 0; i < passwordsList.length; i++) {
      if (passwordsList[i].id == passwordId) {
        passwordsList.removeAt(i);
        _passwords.add(passwordsList);
        return;
      }
    }

    throw PasswordExceptionFailedToDelete();
  }

  Future<void> close() async {
    await _subscription.cancel();
    await _passwords.close();
    _isInitialized = false;
  }
}

class PasswordsStream extends Stream<Iterable<Password>> {
  final StreamController<Iterable<Password>> _controller =
      StreamController.broadcast();

  @override
  StreamSubscription<Iterable<Password>> listen(
    void Function(Iterable<Password> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void add(Iterable<Password> data) {
    _controller.add(data);
  }

  Future<void> close() async {
    _controller.close();
  }
}
