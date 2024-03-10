import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class PasswordOption extends StatelessWidget {
  final String title;
  final List<Widget> widgets;

  const PasswordOption({super.key, required this.title, required this.widgets});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return Column(
      children: [
        Divider(height: 0, color: colors.toastColor),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18)),
              ...widgets,
            ],
          ),
        ),
        Divider(height: 0, color: colors.toastColor),
      ],
    );
  }
}
