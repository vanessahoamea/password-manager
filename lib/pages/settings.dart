import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/theme/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Theme',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: ToggleButtons(
                  borderRadius: BorderRadius.circular(1000),
                  onPressed: (int index) {
                    ThemeMode theme = index == 0
                        ? ThemeMode.light
                        : index == 1
                            ? ThemeMode.dark
                            : ThemeMode.system;
                    context.read<ThemeCubit>().setThemeMode(theme);
                  },
                  isSelected: [
                    themeMode == ThemeMode.light,
                    themeMode == ThemeMode.dark,
                    themeMode == ThemeMode.system,
                  ],
                  children: const [
                    Icon(Icons.light_mode),
                    Icon(Icons.dark_mode),
                    Icon(Icons.devices),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
