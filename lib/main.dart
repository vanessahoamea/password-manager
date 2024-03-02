import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/bloc/theme/theme_cubit.dart';
import 'package:password_manager/components/page_wrapper.dart';
import 'package:password_manager/overlays/loading_screen.dart';
import 'package:password_manager/pages/forgot_password.dart';
import 'package:password_manager/pages/generator.dart';
import 'package:password_manager/pages/login.dart';
import 'package:password_manager/pages/passwords.dart';
import 'package:password_manager/pages/register.dart';
import 'package:password_manager/pages/settings.dart';
import 'package:password_manager/pages/verify_email.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/biometrics/biometrics_service.dart';
import 'package:password_manager/services/local_storage/local_storage_service.dart';
import 'package:password_manager/services/passwords/password_service.dart';
import 'package:password_manager/utils/themes.dart';

void main() {
  runApp(BlocProvider<ThemeCubit>(
    create: (context) => ThemeCubit(LocalStorageService()),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Password Manager',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(
                  AuthService.fromFirebase(),
                  LocalStorageService(),
                  BiometricsService(),
                ),
              ),
              BlocProvider<ManagerBloc>(
                create: (context) => ManagerBloc(
                  PasswordService.fromFirestore(),
                  LocalStorageService(),
                  BiometricsService(),
                ),
              ),
            ],
            child: const HomePage(),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState.isLoading) {
          LoadingScreen.show(
            context: context,
            text: authState.loadingMessage,
          );
        } else {
          LoadingScreen.hide();
        }
      },
      builder: (context, authState) {
        switch (authState.runtimeType) {
          case AuthStateLoggedOut:
            return const LoginPage();
          case AuthStateRegistering:
            return const RegisterPage();
          case AuthStateForgotPassword:
            return const ForgotPasswordPage();
          case AuthStateVerifyEmail:
            return const VerifyEmailPage();
          case AuthStateLoggedIn:
            final user = (authState as AuthStateLoggedIn).user;
            context.read<ManagerBloc>().add(ManagerEventInitialize(user: user));

            return BlocConsumer<ManagerBloc, ManagerState>(
              listener: (context, managerState) {
                //
              },
              builder: (context, managerState) {
                final Widget body;

                switch (managerState.runtimeType) {
                  case ManagerStatePasswordsPage:
                    body = const PasswordsPage();
                    break;
                  case ManagerStateGeneratorPage:
                    body = const GeneratorPage();
                    break;
                  case ManagerStateSettingsPage:
                    body = const SettingsPage();
                    break;
                  default:
                    body = const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                    break;
                }

                return PageWrapper(
                  title: managerState.title ?? '',
                  body: body,
                  navbarIndex: managerState.navbarIndex ?? 0,
                );
              },
            );
          default:
            return const Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
        }
      },
    );
  }
}
