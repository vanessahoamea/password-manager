import 'package:bloc/bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider)
      : super(const AuthStateUninitialized(isLoading: false)) {
    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      emit(const AuthStateLoggedOut(
        isLoading: false,
        rememberUser: false,
        exception: null,
      ));
    });

    on<AuthEventGoToRegister>((event, emit) {
      emit(const AuthStateRegistering(
        isLoading: false,
        isPasswordLongEnough: null,
        isPasswordComplexEnough: null,
        exception: null,
      ));
    });

    on<AuthEventGoToLogIn>((event, emit) {
      emit(const AuthStateLoggedOut(
        isLoading: false,
        rememberUser: false,
        exception: null,
      ));
    });

    on<AuthEventGoToForgotPassword>((event, emit) {
      emit(const AuthStateForgotPassword(
        isLoading: false,
        sentEmail: false,
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

    on<AuthEventValidatePassword>((event, emit) {
      emit(AuthStateRegistering(
        isLoading: false,
        isPasswordLongEnough:
            AuthProvider.validatePasswordLength(event.password),
        isPasswordComplexEnough:
            AuthProvider.validatePasswordComplexity(event.password),
        exception: null,
      ));
    });

    on<AuthEventRegister>((event, emit) async {
      emit((state as AuthStateRegistering).copyWith(
        isLoading: true,
        loadingMessage: 'Creating your account...',
        exception: null,
      ));

      try {
        await authProvider.register(
          email: event.email,
          password: event.password,
          repeatPassword: event.repeatPassword,
        );
        await authProvider.sendEmailVerification();

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

    on<AuthEventUpdateRememberUser>((event, emit) {
      emit(AuthStateLoggedOut(
        isLoading: false,
        rememberUser: event.value,
        exception: null,
      ));
    });

    on<AuthEventLogIn>((event, emit) async {
      emit((state as AuthStateLoggedOut).copyWith(
        isLoading: true,
        loadingMessage: 'Logging you in...',
        exception: null,
      ));

      try {
        final user = await authProvider.logIn(
          email: event.email,
          password: event.password,
        );

        emit((state as AuthStateLoggedOut).copyWith(isLoading: false));

        if (!user.isEmailVerified) {
          emit(const AuthStateVerifyEmail(
            isLoading: false,
            sentEmail: false,
            exception: null,
          ));
        } else {
          emit(AuthStateLoggedIn(isLoading: false, user: user));
        }
      } on Exception catch (e) {
        emit((state as AuthStateLoggedOut).copyWith(
          isLoading: false,
          exception: e,
        ));
      }
    });

    on<AuthEventResetPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        isLoading: true,
        loadingMessage: 'Sending e-mail...',
        sentEmail: false,
        exception: null,
      ));

      try {
        await authProvider.sendPasswordResetEmail(email: event.email);
        emit(const AuthStateForgotPassword(
          isLoading: false,
          sentEmail: true,
          exception: null,
        ));
      } on Exception catch (e) {
        emit(AuthStateForgotPassword(
          isLoading: false,
          sentEmail: false,
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
        await authProvider.sendEmailVerification();
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
      try {
        await authProvider.logOut();
        emit(const AuthStateLoggedOut(
          isLoading: false,
          rememberUser: false,
          exception: null,
        ));
      } on Exception catch (e) {
        // logging out failed in the verify email page
        if (state is AuthStateVerifyEmail) {
          emit((state as AuthStateVerifyEmail).copyWith(exception: e));
        }
        // logging out failed inside the pp
        else {
          //
        }
      }
    });
  }
}
