import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/services/passwords/password.dart';

class SinglePasswordPage extends StatefulWidget {
  final Password? password;
  final String decryptedPassword;

  const SinglePasswordPage({
    super.key,
    required this.password,
    required this.decryptedPassword,
  });

  @override
  State<SinglePasswordPage> createState() => _SinglePasswordPageState();
}

class _SinglePasswordPageState extends State<SinglePasswordPage> {
  final _websiteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    if (widget.password != null) {
      _websiteController.text = widget.password!.website;
      _usernameController.text = widget.password!.username ?? '';
      _passwordController.text = widget.decryptedPassword;
    }
    super.initState();
  }

  @override
  void dispose() {
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.password == null ? 'Add Password' : 'Edit Password';

    return BlocConsumer<ManagerBloc, ManagerState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () {
                if (state is ManagerStateSinglePasswordPage) {
                  context
                      .read<ManagerBloc>()
                      .add(ManagerEventReturnToPreviousState(
                        previousState: state.previousState,
                      ));
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state is ManagerStateSinglePasswordPage) {
                return const Column(
                  children: [
                    // website field

                    // username field

                    // password field
                  ],
                );
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
