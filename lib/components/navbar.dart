import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/extensions/dark_mode.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;

  const Navbar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return NavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.grey,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.key,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          label: 'Passwords',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.security,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          label: 'Generator',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.settings,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          label: 'Settings',
        ),
      ],
      indicatorColor: colors.accentColor,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        if (index == selectedIndex) return;

        if (index == 0) {
          context
              .read<ManagerBloc>()
              .add(const ManagerEventGoToPasswordsPage());
        } else if (index == 1) {
          context
              .read<ManagerBloc>()
              .add(const ManagerEventGoToGeneratorPage());
        } else {
          context.read<ManagerBloc>().add(const ManagerEventGoToSettingsPage());
        }
      },
    );
  }
}
