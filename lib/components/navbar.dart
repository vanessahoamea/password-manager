import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;

  const Navbar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return NavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.key),
              label: 'Passwords',
            ),
            NavigationDestination(
              icon: Icon(Icons.security),
              label: 'Generator',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          indicatorColor: Theme.of(context).colorScheme.primary,
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            if (index == 0) {
              context.read<AuthBloc>().add(const AuthEventGoToPasswordsPage());
            } else if (index == 1) {
              context.read<AuthBloc>().add(const AuthEventGoToGeneratorPage());
            } else {
              context.read<AuthBloc>().add(const AuthEventGoToSettingsPage());
            }
          },
        );
      },
    );
  }
}
