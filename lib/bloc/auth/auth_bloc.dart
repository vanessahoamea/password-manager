import 'package:bloc/bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider)
      : super(const AuthStateUninitialized(isLoading: false)) {
    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      emit(const AuthStateLoggedOut(isLoading: false, exception: null));
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
      emit(const AuthStateLoggedOut(isLoading: false, exception: null));
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
      try {
        await authProvider.register(
          email: event.email,
          password: event.password,
          repeatPassword: event.repeatPassword,
        );
        await authProvider.sendEmailVerification();
        emit(const AuthStateVerifyEmail(
          isLoading: false,
          sentEmail: false,
          exception: null,
        ));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          isLoading: false,
          isPasswordLongEnough:
              AuthProvider.validatePasswordLength(event.password),
          isPasswordComplexEnough:
              AuthProvider.validatePasswordComplexity(event.password),
          exception: e,
        ));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      try {
        final user = await authProvider.logIn(
          email: event.email,
          password: event.password,
        );

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
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });

    on<AuthEventResetPassword>((event, emit) {
      //
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
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
        emit(const AuthStateLoggedOut(isLoading: false, exception: null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });
  }
}
