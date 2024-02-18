import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/pages/forgot_password.dart';
import 'package:password_manager/pages/login.dart';
import 'package:password_manager/pages/register.dart';
import 'package:password_manager/pages/verify_email.dart';
import 'package:password_manager/services/auth/providers/firebase_auth_provider.dart';
import 'package:password_manager/utils/themes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Password Manager',
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.system,
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
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

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthStateLoggedOut:
            return const LoginPage();
          case AuthStateRegistering:
            return const RegisterPage();
          case AuthStateForgotPassword:
            return const ForgotPasswordPage();
          default:
            return const VerifyEmailPage();
        }
      },
    );
  }
}
