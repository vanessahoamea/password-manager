import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:test/test.dart';

import 'exceptions.dart';
import 'providers/mock_auth_provider.dart';

void main() {
  group('Mock authentication', () {
    final authProvider = MockAuthProvider();

    test('Not initialized by default', () {
      expect(authProvider.isInitialized, false);
    });

    test('Can not log out if not initialized', () {
      expect(
        authProvider.logOut(),
        throwsA(const TypeMatcher<AuthExceptionNotInitialized>()),
      );
    });

    test('Should be able to be initialized', () async {
      await authProvider.initialize();
      expect(authProvider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      try {
        authProvider.user;
      } catch (e) {
        expect(e, isA<AuthExceptionUserNotLoggedIn>());
      }
    });

    test('Password must meet requirements when creating an account', () async {
      try {
        await authProvider.register(
          email: 'test@email.com',
          password: 'Testpassword.123',
          repeatPassword: '',
        );
      } catch (e) {
        expect(e, isA<AuthExceptionEmptyFields>());
      }

      try {
        await authProvider.register(
          email: 'test@email.com',
          password: 'weakpassword',
          repeatPassword: 'weakpassword',
        );
      } catch (e) {
        expect(e, isA<AuthExceptionWeakPassword>());
      }

      try {
        await authProvider.register(
          email: 'test@email.com',
          password: 'Testpassword.123',
          repeatPassword: 'Testpassword.456',
        );
      } catch (e) {
        expect(e, isA<AuthExceptionPasswordsDontMatch>());
      }
    });

    test(
        'Registration should delegate to login function and create a salt for the user',
        () async {
      expect(
        authProvider.register(
          email: 'bad@address.com',
          password: 'Goodpassword.456',
          repeatPassword: 'Goodpassword.456',
        ),
        throwsA(const TypeMatcher<AuthExceptionInvalidCredentials>()),
      );

      expect(
        authProvider.register(
          email: 'good@address.com',
          password: 'Badpassword.789',
          repeatPassword: 'Badpassword.789',
        ),
        throwsA(const TypeMatcher<AuthExceptionInvalidCredentials>()),
      );

      final user = await authProvider.register(
        email: 'test@email.com',
        password: 'Testpassword.123',
        repeatPassword: 'Testpassword.123',
      );
      await authProvider.createUserSalt();
      final fetchedSalt = await authProvider.getUserSalt();

      expect(authProvider.user, user);
      expect(user.isEmailVerified, false);
      expect(authProvider.userSalt, isNotNull);
      expect(authProvider.userSalt, fetchedSalt);
    });

    test('Logged in user should be able to get verified', () async {
      try {
        await authProvider.sendEmailVerification(updateTimestamp: false);
        expect(authProvider.user.isEmailVerified, true);
      } catch (e) {
        expect(e, isA<AuthExceptionUserNotLoggedIn>());
      }
    });

    test(
        'Users should not be able to request the verification email to be sent unless 60 seconds have passed since the last one was sent',
        () async {
      // first attempt after registration, will work
      await authProvider.sendEmailVerification();
      await Future.delayed(const Duration(seconds: 1));

      // second attempt after less than 60 seconds since the previous one, will fail
      await expectLater(
        authProvider.sendEmailVerification(),
        throwsA(const TypeMatcher<AuthExceptionEmailLimitExceeded>()),
      );

      await Future.delayed(const Duration(seconds: 61));
      await authProvider.sendEmailVerification();
    }, timeout: const Timeout(Duration(seconds: 100)));

    test('User should be able to log out then log in again', () async {
      await authProvider.logOut();
      final user = await authProvider.logIn(
        email: 'test@email.com',
        password: 'Testpassword.123',
      );
      expect(authProvider.user, user);
    });
  });
}
