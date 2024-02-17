import 'package:flutter/material.dart';
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

  void register() {
    //
  }

  @override
  Widget build(BuildContext context) {
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
            const PasswordRequirements(),
            const SizedBox(height: 30),

            // button and login link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: PrimaryButton(text: 'Register', onTap: register),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                const SizedBox(width: 5),
                Text(
                  'Log in',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
