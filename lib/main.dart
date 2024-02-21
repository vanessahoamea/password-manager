import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/overlays/loading_screen.dart';
import 'package:password_manager/pages/forgot_password.dart';
import 'package:password_manager/pages/generator.dart';
import 'package:password_manager/pages/login.dart';
import 'package:password_manager/pages/passwords.dart';
import 'package:password_manager/pages/register.dart';
import 'package:password_manager/pages/settings.dart';
import 'package:password_manager/pages/verify_email.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/local_storage/local_storage_service.dart';
import 'package:password_manager/utils/themes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Password Manager',
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.system,
    home: MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            AuthService.fromFirebase(),
            const LocalStorageService(),
          ),
        ),
        BlocProvider<ManagerBloc>(
          create: (context) => ManagerBloc(),
        ),
      ],
      child: const HomePage(),
    ),
  ));
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
                switch (managerState.runtimeType) {
                  case ManagerStatePasswordsPage:
                    return const PasswordsPage();
                  case ManagerStateGeneratorPage:
                    return const GeneratorPage();
                  case ManagerStateSettingsPage:
                    return const SettingsPage();
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
