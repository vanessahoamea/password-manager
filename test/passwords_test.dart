import 'package:encrypt/encrypt.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_exceptions.dart';
import 'package:password_manager/services/passwords/password_service.dart';
import 'package:test/test.dart';

import 'exceptions.dart';
import 'providers/mock_database_provider.dart';

void main() {
  group('Mock password management', () {
    final dbProvider = MockDatabaseProvider();

    test('Not initialized by default', () {
      expect(dbProvider.isInitialized, false);
    });

    test('Can\'t access passwords if not initialized', () {
      try {
        dbProvider.allPasswords(userId: dbProvider.user.id);
      } catch (e) {
        expect(e, isA<AuthExceptionNotInitialized>());
      }
    });

    test('Should be able to be initialized', () async {
      await dbProvider.initialize();
      expect(dbProvider.isInitialized, true);
    });

    test('User should be able to access their passwords after initialization',
        () async {
      dbProvider.allPasswords(userId: dbProvider.user.id);
      final passwords = dbProvider.currentPasswords;

      expect(passwords, isNotNull);
      expect(passwords!.length, 2);
    });

    test('Trying to access a password with an invalid ID throws an error',
        () async {
      try {
        await dbProvider.getPassword(passwordId: 'doesnt_exist');
      } catch (e) {
        expect(e, isA<PasswordExceptionFailedToGetOne>());
      }
    });

    test(
        'A valid encryption key and IV pair is needed to encrypt and decrypt passwords',
        () async {
      try {
        PasswordService.encrypt(
          plaintextPassword: 'test_password_123',
          encryptionKey: List<int>.filled(16, 0),
          iv: IV.fromLength(5),
        );
      } catch (e) {
        expect(e, isA<PasswordExceptionInvalidKey>());
      }

      const plaintextPassword = 'test_password_123';
      final encryptedPassword = await PasswordService.encrypt(
        plaintextPassword: plaintextPassword,
        encryptionKey: dbProvider.encryptionKey,
        iv: dbProvider.iv,
      );
      final decryptedPassword = await PasswordService.decrypt(
        encryptedPassword: encryptedPassword,
        encryptionKey: dbProvider.encryptionKey,
        iv: dbProvider.iv,
      );

      expect(decryptedPassword, plaintextPassword);
    });

    test('User should be able to add a new password', () async {
      final encryptedPassword = await PasswordService.encrypt(
        plaintextPassword: 'test_password_123',
        encryptionKey: dbProvider.encryptionKey,
        iv: dbProvider.iv,
      );

      try {
        await dbProvider.createPassword(
            password: Password(
          userId: dbProvider.user.id,
          website: '',
          username: 'test_username',
          encryptedPassword: encryptedPassword,
        ));
      } catch (e) {
        expect(e, isA<PasswordExceptionEmptyFields>());
      }

      await dbProvider.createPassword(
          password: Password(
        id: 'third_dummy',
        userId: dbProvider.user.id,
        website: 'Test Website',
        username: 'test_username',
        encryptedPassword: encryptedPassword,
      ));

      expect(dbProvider.currentPasswords!.length, 3);
    });

    test('User should be able to edit an existing password', () async {
      const plaintextPassword = r'MyNewGooglePassword!@#$%^';
      final encryptedPassword = await PasswordService.encrypt(
        plaintextPassword: plaintextPassword,
        encryptionKey: dbProvider.encryptionKey,
        iv: dbProvider.iv,
      );

      try {
        await dbProvider.updatePassword(
          password: Password(
            id: 'doesnt_exist',
            userId: dbProvider.user.id,
            website: 'Something That Doesn\'t Exist',
            encryptedPassword: encryptedPassword,
          ),
        );
      } catch (e) {
        expect(e, isA<PasswordExceptionFailedToUpdate>());
      }

      await dbProvider.updatePassword(
        password: Password(
          id: 'first_dummy',
          userId: dbProvider.user.id,
          website: 'Google',
          encryptedPassword: encryptedPassword,
        ),
      );

      final updatedPassword =
          await dbProvider.getPassword(passwordId: 'first_dummy');
      final decryptedPassword = await PasswordService.decrypt(
        encryptedPassword: updatedPassword.encryptedPassword,
        encryptionKey: dbProvider.encryptionKey,
        iv: dbProvider.iv,
      );

      expect(decryptedPassword, plaintextPassword);
    });

    test('User should be able to delete an existing password', () async {
      try {
        await dbProvider.deletePassword(passwordId: 'doesnt_exist');
      } catch (e) {
        expect(e, isA<PasswordExceptionFailedToDelete>());
        expect(dbProvider.currentPasswords!.length, 3);
      }

      await dbProvider.deletePassword(passwordId: 'third_dummy');
      expect(dbProvider.currentPasswords!.length, 2);
    });

    test('Should be able to close database connection', () async {
      await dbProvider.close();
      expect(dbProvider.isInitialized, false);
    });
  });
}
