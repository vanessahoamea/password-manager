import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/primary_input_field.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/utils/dialogs/error_dialog.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          switch (state.exception.runtimeType) {
            case AuthExceptionEmptyFields:
              showErrorDialog(context, 'All fields are required.');
              break;
            case AuthExceptionInvalidEmail:
              showErrorDialog(
                context,
                'The provided e-mail address is not formatted correctly.',
              );
              break;
            case AuthExceptionInvalidCredentials:
              showErrorDialog(context, 'The master password is incorrect.');
              break;
            case AuthExceptionUserNotLoggedIn:
            case AuthExceptionGeneric:
              showErrorDialog(
                context,
                'Something went wrong. Try again later.',
              );
              break;
            default:
              break;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // icon and text
                const Icon(Icons.lock, size: 80),
                const SizedBox(height: 2.5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Log in to manage your passwords',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),

                // input fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PrimaryInputField(
                    controller: emailController,
                    hintText: 'E-mail address',
                    obscureText: false,
                    initialValue:
                        state is AuthStateLoggedOut && state.cachedEmail != null
                            ? state.cachedEmail
                            : '',
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PrimaryInputField(
                    controller: passwordController,
                    hintText: 'Master password',
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10),

                // remember email option and password reset link
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 25.0,
                            height: 25.0,
                            child: Checkbox(
                              value: state is AuthStateLoggedOut
                                  ? state.rememberUser
                                  : false,
                              onChanged: (value) {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventUpdateRememberUser(
                                      value: value ?? false,
                                    ));
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text('Remember me'),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventGoToForgotPassword());
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: colors.secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // button and registration link
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PrimaryButton(
                    text: 'Log in',
                    onTap: () {
                      context.read<AuthBloc>().add(AuthEventLogIn(
                            email: emailController.text,
                            password: passwordController.text,
                            rememberUser: state is AuthStateLoggedOut
                                ? state.rememberUser
                                : false,
                          ));
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventGoToRegister());
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
