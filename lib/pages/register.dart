import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/components/password_requirements.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/primary_input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon and text
              const Icon(Icons.lock, size: 80),
              const SizedBox(height: 2.5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Create an account to safely store your passwords',
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
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: PrimaryInputField(
                  controller: passwordController,
                  hintText: 'Master password',
                  obscureText: true,
                  onChanged: (value) {
                    context
                        .read<AuthBloc>()
                        .add(AuthEventValidatePassword(password: value));
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: PrimaryInputField(
                  controller: confirmPasswordController,
                  hintText: 'Repeat master password',
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 10),

              // password requirements
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthStateRegistering) {
                    return PasswordRequirements(
                      isPasswordLongEnough: state.isPasswordLongEnough,
                      isPasswordComplexEnough: state.isPasswordComplexEnough,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: PrimaryButton(
                  text: 'Register',
                  onTap: () {
                    context.read<AuthBloc>().add(AuthEventRegister(
                          email: emailController.text,
                          password: passwordController.text,
                          repeatPassword: confirmPasswordController.text,
                        ));
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthEventGoToLogIn());
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
    );
  }
}
