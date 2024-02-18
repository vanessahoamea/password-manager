import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/primary_input_field.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/utils/dialogs/error_dialog.dart';
import 'package:password_manager/utils/dialogs/success_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateForgotPassword) {
          if (state.sentEmail) {
            showSuccessDialog(
              context,
              'We have sent you the password reset e-mail. Please check your inbox (including the spam folder).',
            );
            context.read<AuthBloc>().add(const AuthEventGoToForgotPassword());
          }

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
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon and text
              const Icon(Icons.lock_reset, size: 80),
              const SizedBox(height: 2.5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Recover master password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 2.5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Enter your e-mail address below and we will send you a message containing a link that allows you to reset your master password.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // input field and button
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
                child: PrimaryButton(
                  text: 'Send password recovery link',
                  onTap: () {
                    context.read<AuthBloc>().add(
                        AuthEventResetPassword(email: emailController.text));
                  },
                ),
              ),
              const SizedBox(height: 30),

              // login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('All done?'),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthEventGoToLogIn());
                    },
                    child: Text(
                      'Return to login',
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
      ),
    );
  }
}
