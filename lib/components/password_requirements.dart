import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: colors.secondaryTextColor,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  "Password must be at least 8 characters long",
                  style: TextStyle(
                    color: colors.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: colors.secondaryTextColor,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  "Password must contain one uppercase letter, one number, and one special character",
                  style: TextStyle(
                    color: colors.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
