import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/theme/theme_cubit.dart';

class ThemeModal extends StatelessWidget {
  final void Function(ThemeMode) onTap;

  const ThemeModal({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final List<ThemeOption> themeOptions = [
      const ThemeOption(
        name: 'Light',
        icon: Icons.light_mode,
        theme: ThemeMode.light,
      ),
      const ThemeOption(
        name: 'Dark',
        icon: Icons.dark_mode,
        theme: ThemeMode.dark,
      ),
      const ThemeOption(
        name: 'System',
        icon: Icons.devices,
        theme: ThemeMode.system,
      ),
    ];

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, selectedTheme) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: themeOptions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(themeOptions[index].icon),
                title: Text(themeOptions[index].name),
                trailing: selectedTheme == themeOptions[index].theme
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  onTap(themeOptions[index].theme);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ThemeOption {
  final String name;
  final IconData icon;
  final ThemeMode theme;

  const ThemeOption({
    required this.name,
    required this.icon,
    required this.theme,
  });
}
