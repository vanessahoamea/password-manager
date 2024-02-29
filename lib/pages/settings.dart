import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/bloc/theme/theme_cubit.dart';
import 'package:password_manager/components/theme_modal.dart';
import 'package:password_manager/utils/dialogs/confirmation_dialog.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return Column(
      children: [
        // theme
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, selectedTheme) {
            return ListTile(
              title: const Text('Theme Mode', style: TextStyle(fontSize: 18)),
              leading: const Icon(Icons.palette_outlined),
              subtitle: Text(
                selectedTheme == ThemeMode.light
                    ? 'Light'
                    : selectedTheme == ThemeMode.dark
                        ? 'Dark'
                        : 'System',
                style: TextStyle(color: colors.secondaryTextColor),
              ),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
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

        // log out
        BlocBuilder<ManagerBloc, ManagerState>(
          builder: (context, managerState) {
            final String userEmail =
                (managerState as ManagerStateSettingsPage).user!.email;

            return ListTile(
              title: const Text('Log Out', style: TextStyle(fontSize: 18)),
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
            );
          },
        ),
        Divider(height: 0, color: Colors.grey.withOpacity(0.5)),
      ],
    );
  }
}
