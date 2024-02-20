import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/components/navbar.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Password'),
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
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }
}
