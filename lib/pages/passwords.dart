import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/components/passwords_list.dart';
import 'package:password_manager/components/search_field.dart';
import 'package:password_manager/services/passwords/password.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final _searchController = TextEditingController();

  @override
  dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // search bar
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: SearchField(
                              controller: _searchController,
                              onChanged: (value) {
                                context
                                    .read<ManagerBloc>()
                                    .add(ManagerEventFilterPasswords(
                                      term: value,
                                      passwords:
                                          snapshot.data as Iterable<Password>,
                                    ));
                              },
                            ),
                          ),

                          // passwords list
                          PasswordsList(
                            passwords: state.filteredPasswords ??
                                snapshot.data as Iterable<Password>,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
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
