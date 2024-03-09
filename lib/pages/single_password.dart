import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/components/secondary_button.dart';
import 'package:password_manager/components/secondary_input_field.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/services/passwords/password_exceptions.dart';
import 'package:password_manager/utils/dialogs/confirmation_dialog.dart';
import 'package:password_manager/utils/dialogs/error_dialog.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

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
  final _linkRecoginzer = TapGestureRecognizer();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    if (widget.password != null) {
      _websiteController.text = widget.password!.website;
      _usernameController.text = widget.password!.username ?? '';
      _passwordController.text = widget.decryptedPassword;
      _linkRecoginzer.onTap = () {
        if (!_hasUnsavedChanges) {
          context
              .read<ManagerBloc>()
              .add(const ManagerEventGoToGeneratorPage());
        } else {
          showConfirmationDialog(
            context,
            'You have unsaved changes',
            'Are you sure you want to leave? Your changes will lost unless you save them.',
          ).then((value) {
            if (value) {
              context
                  .read<ManagerBloc>()
                  .add(const ManagerEventGoToGeneratorPage());
            }
          });
        }
      };
    }
    super.initState();
  }

  @override
  void dispose() {
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _linkRecoginzer.dispose();
    super.dispose();
  }

  void _updateHasUnsavedChanges() {
    final password = widget.password;
    if (password != null) {
      _hasUnsavedChanges = (_websiteController.text != password.website) ||
          (_usernameController.text != (password.username ?? '')) ||
          (_passwordController.text != widget.decryptedPassword);
    } else {
      _hasUnsavedChanges = _hasUnsavedChanges ||
          _websiteController.text.isNotEmpty ||
          _usernameController.text.isNotEmpty ||
          _passwordController.text.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return BlocConsumer<ManagerBloc, ManagerState>(
      listener: (context, state) {
        if (state is ManagerStateSinglePasswordPage) {
          switch (state.exception.runtimeType) {
            case PasswordExceptionFailedToCreate:
              showErrorDialog(
                context,
                'Password couldn\'t be added. Try again later.',
              );
              break;
            case PasswordExceptionFailedToUpdate:
              showErrorDialog(
                context,
                'Password couldn\'t be updated. Try again later.',
              );
              break;
            case PasswordExceptionFailedToDelete:
              showErrorDialog(
                context,
                'Password couldn\'t be deleted. Try again later.',
              );
              break;
            case PasswordExceptionEmptyFields:
              showErrorDialog(
                context,
                'The website and password fields can\'t be blank.',
              );
              break;
            case PasswordExceptionInvalidKey:
              showErrorDialog(
                context,
                'Something went wrong. Try again later.',
              );
              break;
            default:
              break;
          }
        }
      },
      builder: (context, state) {
        state as ManagerStateSinglePasswordPage;
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.password == null ? "Add" : "Edit"} Password'),
            leading: IconButton(
              onPressed: () {
                if (!_hasUnsavedChanges) {
                  context
                      .read<ManagerBloc>()
                      .add(const ManagerEventGoToPasswordsPage());
                } else {
                  showConfirmationDialog(
                    context,
                    'You have unsaved changes',
                    'Are you sure you want to leave? Your changes will be lost unless you save them.',
                  ).then((value) {
                    if (value) {
                      context
                          .read<ManagerBloc>()
                          .add(const ManagerEventGoToPasswordsPage());
                    }
                  });
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // input fields
                SecondaryInputField(
                  controller: _websiteController,
                  labelText: 'Website',
                  obscureText: false,
                  onChanged: (_) => _updateHasUnsavedChanges(),
                ),
                const SizedBox(height: 10),
                SecondaryInputField(
                  controller: _usernameController,
                  labelText: 'Username (optional)',
                  obscureText: false,
                  onChanged: (_) => _updateHasUnsavedChanges(),
                ),
                const SizedBox(height: 10),
                SecondaryInputField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  isObscured: !state.showPassword,
                  toggleVisibility: () {
                    context
                        .read<ManagerBloc>()
                        .add(ManagerEventUpdateSinglePasswordState(
                          showPassword: !state.showPassword,
                        ));
                  },
                  onChanged: (_) => _updateHasUnsavedChanges(),
                ),
                const SizedBox(height: 10),

                // link to generator page
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              'Make sure to set a strong, hard to guess password. If you need help coming up with a good password, check out our ',
                        ),
                        TextSpan(
                          text: 'password generator',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: _linkRecoginzer,
                        ),
                        const TextSpan(text: '.'),
                      ],
                      style: TextStyle(color: colors.secondaryTextColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // save button + delete button (for existing passwords)
                PrimaryButton(
                  text: 'Save',
                  onTap: () {
                    context.read<ManagerBloc>().add(ManagerEventSavePassword(
                          id: widget.password?.id,
                          website: _websiteController.text,
                          username: _usernameController.text.isNotEmpty
                              ? _usernameController.text
                              : null,
                          password: _passwordController.text,
                        ));
                  },
                ),
                if (widget.password != null)
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      SecondaryButton(
                        text: 'Delete',
                        onTap: () {
                          showConfirmationDialog(
                            context,
                            'Delete password',
                            'Are you sure you want to delete your password for ${widget.password!.website}?',
                          ).then((value) {
                            if (value) {
                              context
                                  .read<ManagerBloc>()
                                  .add(ManagerEventDeletePassword(
                                    passwordId: widget.password!.id!,
                                  ));
                            }
                          });
                        },
                        color: colors.errorColor,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
