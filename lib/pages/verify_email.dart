import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/secondary_button.dart';
import 'package:password_manager/utils/dialogs/error_dialog.dart';
import 'package:password_manager/utils/dialogs/success_dialog.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateVerifyEmail) {
          if (state.sentEmail) {
            showSuccessDialog(
              context,
              'We have sent you the confirmation e-mail. Please check your inbox (including the spam folder).',
            );
            context.read<AuthBloc>().add(const AuthEventGoToVerifyEmail());
          }

          if (state.exception != null) {
            showErrorDialog(
              context,
              'Something went wrong. Try again later.',
            );
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // icon and text
                  const Icon(Icons.mail, size: 80),
                  const SizedBox(height: 2.5),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Verify your e-mail',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 2.5),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'We have sent you a verification e-mail to confirm your identity. Please check your inbox and click on the link in the e-mail to finish setting up your account.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
              
                  // buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Resend e-mail',
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthEventSendEmailVerification());
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SecondaryButton(
                              text: 'Back to login',
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthEventLogOut());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
