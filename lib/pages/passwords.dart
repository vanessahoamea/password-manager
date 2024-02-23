import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';

class PasswordsPage extends StatelessWidget {
  const PasswordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerBloc, ManagerState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        return StreamBuilder(
          stream: (state as ManagerStatePasswordsPage).passwords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                return const SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // search bar

                        // passwords list
                      ],
                    ),
                  ),
                );
              default:
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
            }
          },
        );
      },
    );
  }
}
