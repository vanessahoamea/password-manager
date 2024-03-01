import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/bloc/theme/theme_cubit.dart';
import 'package:password_manager/components/theme_modal.dart';
import 'package:password_manager/extensions/capitalize_string.dart';
import 'package:password_manager/utils/dialogs/confirmation_dialog.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return Column(
      children: [
        // switch theme
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, selectedTheme) {
            return ListTile(
              title: const Text('Theme Mode', style: TextStyle(fontSize: 18)),
              leading: const Icon(Icons.palette_outlined),
              subtitle: Text(
                selectedTheme.name.capitalize(),
                style: TextStyle(color: colors.secondaryTextColor),
              ),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (context) {
                    return ThemeModal(
                      onTap: (theme) {
                        context.read<ThemeCubit>().setThemeMode(theme);
                      },
                    );
                  },
                );
              },
            );
          },
        ),
        Divider(height: 0, color: Colors.grey.withOpacity(0.5)),

        BlocBuilder<ManagerBloc, ManagerState>(
          builder: (context, managerState) {
            if (managerState is ManagerStateSettingsPage) {
              final String userEmail = managerState.user!.email;
              final bool supportsBiometrics = managerState.supportsBiometrics;
              final bool hasBiometricsEnabled =
                  managerState.hasBiometricsEnabled;

              return Column(
                children: [
                  // toggle biometrics auth (if supported)
                  Builder(
                    builder: (BuildContext context) {
                      if (supportsBiometrics) {
                        return Column(
                          children: [
                            ListTile(
                              title: const Text(
                                'Log In with Biometrics',
                                style: TextStyle(fontSize: 18),
                              ),
                              leading: const Icon(Icons.person),
                              subtitle: Text(
                                'Use biometrics enabled on your device in addition to your master password to authenticate.',
                                style:
                                    TextStyle(color: colors.secondaryTextColor),
                              ),
                              trailing: Switch(
                                value: hasBiometricsEnabled,
                                onChanged: (value) {
                                  context.read<ManagerBloc>().add(
                                      const ManagerEventToggleBiometrics());
                                },
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),

                  // log out
                  ListTile(
                    title:
                        const Text('Log Out', style: TextStyle(fontSize: 18)),
                    leading: const Icon(Icons.logout),
                    subtitle: Text(
                      userEmail,
                      style: TextStyle(color: colors.secondaryTextColor),
                    ),
                    onTap: () {
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
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        Divider(height: 0, color: Colors.grey.withOpacity(0.5)),
      ],
    );
  }
}
