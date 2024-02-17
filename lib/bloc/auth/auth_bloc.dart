import 'package:bloc/bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/services/auth/providers/auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      emit(const AuthStateLoggedOut(exception: null));
    });

    on<AuthEventGoToRegister>((event, emit) {
      emit(const AuthStateRegistering(
        isPasswordLongEnough: null,
        isPasswordComplexEnough: null,
        exception: null,
      ));
    });

    on<AuthEventGoToLogIn>((event, emit) {
      emit(const AuthStateLoggedOut(exception: null));
    });

    on<AuthEventValidatePassword>((event, emit) {
      emit(AuthStateRegistering(
        isPasswordLongEnough:
            authProvider.validatePasswordLength(event.password),
        isPasswordComplexEnough:
            authProvider.validatePasswordComplexity(event.password),
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
        emit(const AuthStateVerifyEmail());
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          isPasswordLongEnough:
              authProvider.validatePasswordLength(event.password),
          isPasswordComplexEnough:
              authProvider.validatePasswordComplexity(event.password),
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
          emit(const AuthStateVerifyEmail());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    on<AuthEventResetPassword>((event, emit) {
      //
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await authProvider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await authProvider.logOut();
        emit(const AuthStateLoggedOut(exception: null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });
  }
}
