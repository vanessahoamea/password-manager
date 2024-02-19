import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
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
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        AuthService.fromFirebase(),
        const LocalStorageService(),
      ),
      child: const HomePage(),
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen.show(
            context: context,
            text: state.loadingMessage,
          );
        } else {
          LoadingScreen.hide();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthStateLoggedOut:
            return const LoginPage();
          case AuthStateRegistering:
            return const RegisterPage();
          case AuthStateForgotPassword:
            return const ForgotPasswordPage();
          case AuthStateVerifyEmail:
            return const VerifyEmailPage();
          case AuthStatePasswordsPage:
            return const PasswordsPage();
          case AuthStateGeneratorPage:
            return const GeneratorPage();
          case AuthStateSettingsPage:
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
  }
}
