import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/components/navbar.dart';
import 'package:password_manager/services/auth/auth_exceptions.dart';
import 'package:password_manager/utils/dialogs/error_dialog.dart';

class PasswordsPage extends StatelessWidget {
  const PasswordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStatePasswordsPage) {
          if (state.exception is AuthExceptionUserNotLoggedIn) {
            showErrorDialog(
              context,
              'Something went wrong. Try again later.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Passwords'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
            ),
          ],
        ),
        body: const Column(
          children: [
            //
          ],
        ),
        bottomNavigationBar: const Navbar(selectedIndex: 0),
      ),
    );
  }
}
