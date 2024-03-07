import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/secondary_input_field.dart';
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state is ManagerStateSinglePasswordPage) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // website field
                      SecondaryInputField(
                        controller: _websiteController,
                        labelText: 'Website',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      // username field
                      SecondaryInputField(
                        controller: _usernameController,
                        labelText: 'Username (optional)',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      // password field
                      SecondaryInputField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        isObscured: true,
                        toggleVisibility: () {
                          //
                        },
                      ),
                      const SizedBox(height: 30),

                      PrimaryButton(
                        text: 'Save',
                        onTap: () {
                          //
                        },
                      ),
                    ],
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
            },
          ),
        );
      },
    );
  }
}
