import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/components/navbar.dart';
import 'package:password_manager/utils/dialogs/confirmation_dialog.dart';

class PageWrapper extends StatelessWidget {
  final String title;
  final Widget body;
  final int navbarIndex;

  const PageWrapper({
    super.key,
    required this.title,
    required this.body,
    required this.navbarIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              showConfirmationDialog(
                context,
                'Log out',
                'Are you sure you want to log out of the application?',
              ).then((value) {
                if (value) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }
              });
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: Navbar(selectedIndex: navbarIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
        },
        shape: const CircleBorder(),
        tooltip: 'Add password',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
