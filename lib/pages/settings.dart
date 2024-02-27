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
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: const Text('Light Theme'),
                    leading: Radio(
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: (value) {
                        context
                            .read<ThemeCubit>()
                            .setThemeMode(ThemeMode.light);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Dark Theme'),
                    leading: Radio(
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: (value) {
                        context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('System Theme'),
                    leading: Radio(
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: (value) {
                        context
                            .read<ThemeCubit>()
                            .setThemeMode(ThemeMode.system);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
