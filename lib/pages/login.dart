import 'package:flutter/material.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/primary_input_field.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberUser = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    //
  }

  void toggleRememberUser(bool? value) {
    setState(() {
      rememberUser = value ?? !rememberUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

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
                          value: rememberUser,
                          onChanged: toggleRememberUser,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('Remember me'),
                    ],
                  ),
                  Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: colors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // button and registration link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: PrimaryButton(text: 'Log in', onTap: login),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                const SizedBox(width: 5),
                Text(
                  'Register now',
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
