import 'package:bloc/bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/services/ad/ad_service.dart';
import 'package:password_manager/services/auth/app_user.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/biometrics/biometrics_service.dart';
import 'package:password_manager/services/local_storage/local_storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late bool rememberUser;
  late Map<String, String> credentials;
  late bool areBiometricsSet;
  late bool hasBiometricsEnabled;

  AuthBloc(
    AuthService authService,
    LocalStorageService localStorageService,
    BiometricsService biometricsService,
    AdService adService,
  ) : super(const AuthStateUninitialized(isLoading: false)) {
    on<AuthEventInitialize>((event, emit) async {
      await Future.wait([authService.initialize(), adService.initialize()]);

      final [
        rememberUser as bool,
        credentials as Map<String, String>,
        areBiometricsSet as bool
      ] = await Future.wait([
        localStorageService.getRememberUser(),
        localStorageService.getCredentials(),
        biometricsService.areBiometricsSet()
      ]);
      this.rememberUser = rememberUser;
      this.credentials = credentials;
      this.areBiometricsSet = areBiometricsSet;
      hasBiometricsEnabled =
          areBiometricsSet && localStorageService.getHasBiometricsEnabled();

      emit(AuthStateLoggedOut(
        isLoading: false,
        rememberUser: rememberUser,
        showPassword: false,
        hasBiometricsEnabled: hasBiometricsEnabled,
        cachedEmail: credentials['email'],
        exception: null,
      ));
    });

    on<AuthEventGoToRegister>((event, emit) {
      emit(const AuthStateRegistering(
        isLoading: false,
        showPassword: false,
        showRepeatPassword: false,
        isPasswordLongEnough: null,
        isPasswordComplexEnough: null,
        exception: null,
      ));
    });

    on<AuthEventGoToLogIn>((event, emit) async {
      emit(AuthStateLoggedOut(
        isLoading: false,
        rememberUser: rememberUser,
        hasBiometricsEnabled: hasBiometricsEnabled,
        cachedEmail: credentials['email'],
        showPassword: false,
        exception: null,
      ));
    });

    on<AuthEventGoToVerifyEmail>((event, emit) {
      emit(const AuthStateVerifyEmail(
        isLoading: false,
        sentEmail: false,
        exception: null,
      ));
    });

    on<AuthEventUpdateRegisteringState>((event, emit) {
      emit((state as AuthStateRegistering).copyWith(
        showPassword: event.showPassword,
        showRepeatPassword: event.showRepeatPassword,
      ));
    });

    on<AuthEventValidatePassword>((event, emit) {
      emit((state as AuthStateRegistering).copyWith(
        isPasswordLongEnough:
            AuthService.validatePasswordLength(event.password),
        isPasswordComplexEnough:
            AuthService.validatePasswordComplexity(event.password),
      ));
    });

    on<AuthEventRegister>((event, emit) async {
      emit((state as AuthStateRegistering).copyWith(
        isLoading: true,
        loadingMessage: 'Creating your account...',
        exception: null,
      ));

      try {
        await authService.register(
          email: event.email,
          password: event.password,
          repeatPassword: event.repeatPassword,
        );
        await Future.wait([
          authService.createUserSalt(),
          authService.sendEmailVerification()
        ]);

        emit((state as AuthStateRegistering).copyWith(isLoading: false));
        emit(const AuthStateVerifyEmail(
          isLoading: false,
          sentEmail: false,
          exception: null,
        ));
      } on Exception catch (e) {
        emit((state as AuthStateRegistering).copyWith(
          isLoading: false,
          exception: e,
        ));
      }
    });

    on<AuthEventUpdateLoggedOutState>((event, emit) {
      emit((state as AuthStateLoggedOut).copyWith(
        rememberUser: event.rememberUser,
        showPassword: event.showPassword,
      ));
    });

    on<AuthEventLogIn>((event, emit) async {
      emit((state as AuthStateLoggedOut).copyWith(
        isLoading: true,
        loadingMessage: 'Logging you in...',
        exception: null,
      ));

      try {
        final [user as AppUser, _] = await Future.wait([
          authService.logIn(email: event.email, password: event.password),
          event.rememberUser
              ? localStorageService.rememberUser(
                  email: event.email,
                  password: event.password,
                )
              : localStorageService.forgetUser()
        ]);

        rememberUser = event.rememberUser;
        credentials['email'] = event.rememberUser ? event.email : '';
        credentials['password'] = event.rememberUser ? event.password : '';

        emit((state as AuthStateLoggedOut).copyWith(isLoading: false));

        if (!user.isEmailVerified) {
          emit(const AuthStateVerifyEmail(
            isLoading: false,
            sentEmail: false,
            exception: null,
          ));
        } else {
          final salt = await authService.getUserSalt();
          await localStorageService.createEncryptionKey(
            masterPassword: event.password,
            salt: salt,
          );
          emit(AuthStateLoggedIn(isLoading: false, user: user));
        }
      } on Exception catch (e) {
        emit((state as AuthStateLoggedOut).copyWith(
          isLoading: false,
          exception: e,
        ));
      }
    });

    on<AuthEventAuthenticateWithBiometrics>((event, emit) async {
      emit((state as AuthStateLoggedOut).copyWith(
        isLoading: true,
        loadingMessage: 'Logging you in...',
        exception: null,
      ));

      try {
        await biometricsService.authenticateWithBiometrics();
        final user = await authService.logIn(
          email: credentials['email'] ?? '',
          password: credentials['password'] ?? '',
        );

        final salt = await authService.getUserSalt();
        await localStorageService.createEncryptionKey(
          masterPassword: credentials['password'] ?? '',
          salt: salt,
        );

        emit((state as AuthStateLoggedOut).copyWith(isLoading: false));
        emit(AuthStateLoggedIn(isLoading: false, user: user));
      } on Exception catch (e) {
        emit((state as AuthStateLoggedOut).copyWith(
          isLoading: false,
          exception: e,
        ));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      emit(const AuthStateVerifyEmail(
        isLoading: true,
        loadingMessage: 'Sending e-mail...',
        sentEmail: false,
        exception: null,
      ));

      try {
        await authService.sendEmailVerification();
        emit(const AuthStateVerifyEmail(
          isLoading: false,
          sentEmail: true,
          exception: null,
        ));
      } on Exception catch (e) {
        emit(AuthStateVerifyEmail(
          isLoading: false,
          sentEmail: false,
          exception: e,
        ));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      switch (state.runtimeType) {
        case AuthStateVerifyEmail:
          emit((state as AuthStateVerifyEmail).copyWith(
            isLoading: true,
            loadingMessage: 'Logging you out...',
          ));
          break;
        case AuthStateLoggedIn:
          emit((state as AuthStateLoggedIn).copyWith(
            isLoading: true,
            loadingMessage: 'Logging you out...',
          ));
          break;
        default:
          break;
      }

      try {
        hasBiometricsEnabled =
            areBiometricsSet && localStorageService.getHasBiometricsEnabled();
        await Future.wait([
          authService.logOut(),
          localStorageService.deleteEncryptionKey(),
        ]);

        switch (state.runtimeType) {
          case AuthStateVerifyEmail:
            emit((state as AuthStateVerifyEmail).copyWith(isLoading: false));
            break;
          case AuthStateLoggedIn:
            emit((state as AuthStateLoggedIn).copyWith(isLoading: false));
            break;
          default:
            break;
        }

        emit(AuthStateLoggedOut(
          isLoading: false,
          rememberUser: rememberUser,
          showPassword: false,
          hasBiometricsEnabled: hasBiometricsEnabled,
          cachedEmail: credentials['email'],
          exception: null,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          isLoading: false,
          rememberUser: rememberUser,
          showPassword: false,
          hasBiometricsEnabled: hasBiometricsEnabled,
          cachedEmail: credentials['email'],
          exception: e,
        ));
      }
    });
  }
}
