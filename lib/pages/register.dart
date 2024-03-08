import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/components/password_requirements.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/primary_input_field.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/utils/dialogs/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegistering) {
          switch (state.exception.runtimeType) {
            case AuthExceptionEmptyFields:
              showErrorDialog(context, 'All fields are required.');
              break;
            case AuthExceptionWeakPassword:
              showErrorDialog(
                context,
                'The master password must be at least 8 characters long and contain at least one uppercase letter, one number and one special character.',
              );
              break;
            case AuthExceptionPasswordsDontMatch:
              showErrorDialog(context, 'The provided passwords don\'t match.');
              break;
            case AuthExceptionInvalidEmail:
              showErrorDialog(
                context,
                'The provided e-mail address is not formatted correctly.',
              );
              break;
            case AuthExceptionEmailAlreadyInUse:
              showErrorDialog(
                context,
                'The provided e-mail address is already in use.',
              );
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // icon and text
                    const Icon(Icons.lock, size: 80),
                    const SizedBox(height: 2.5),
                    const Text(
                      'Create an account to safely store your passwords',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // input fields
                    PrimaryInputField(
                      controller: _emailController,
                      hintText: 'E-mail address',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    PrimaryInputField(
                      controller: _passwordController,
                      hintText: 'Master password',
                      obscureText: true,
                      isObscured: state is AuthStateRegistering
                          ? !state.showPassword
                          : true,
                      onChanged: (value) {
                        context
                            .read<AuthBloc>()
                            .add(AuthEventValidatePassword(password: value));
                      },
                      toggleVisibility: () {
                        context
                            .read<AuthBloc>()
                            .add(AuthEventUpdateRegisteringState(
                              showPassword: state is AuthStateRegistering
                                  ? !state.showPassword
                                  : false,
                            ));
                      },
                    ),
                    const SizedBox(height: 10),
                    PrimaryInputField(
                      controller: _confirmPasswordController,
                      hintText: 'Repeat master password',
                      obscureText: true,
                      isObscured: state is AuthStateRegistering
                          ? !state.showRepeatPassword
                          : true,
                      toggleVisibility: () {
                        context
                            .read<AuthBloc>()
                            .add(AuthEventUpdateRegisteringState(
                              showRepeatPassword: state is AuthStateRegistering
                                  ? !state.showRepeatPassword
                                  : false,
                            ));
                      },
                    ),
                    const SizedBox(height: 10),

                    // password requirements
                    Builder(
                      builder: (context) {
                        if (state is AuthStateRegistering) {
                          return PasswordRequirements(
                            isPasswordLongEnough: state.isPasswordLongEnough,
                            isPasswordComplexEnough:
                                state.isPasswordComplexEnough,
                          );
                        } else {
                          return const PasswordRequirements(
                            isPasswordLongEnough: null,
                            isPasswordComplexEnough: null,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),

                    // button and login link
                    PrimaryButton(
                      text: 'Register',
                      onTap: () {
                        context.read<AuthBloc>().add(AuthEventRegister(
                              email: _emailController.text,
                              password: _passwordController.text,
                              repeatPassword: _confirmPasswordController.text,
                            ));
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventGoToLogIn());
                          },
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
