import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class PasswordRequirements extends StatelessWidget {
  final bool? isPasswordLongEnough;
  final bool? isPasswordComplexEnough;

  const PasswordRequirements({
    super.key,
    required this.isPasswordLongEnough,
    required this.isPasswordComplexEnough,
  });

  Color getColor(bool? value, GlobalColors colors) {
    if (value != null && value) {
      return colors.successColor;
    }

    if (value != null && !value) {
      return colors.errorColor;
    }

    return colors.secondaryTextColor;
  }

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
                  color: getColor(isPasswordLongEnough, colors),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  "Password must be at least 8 characters long",
                  style: TextStyle(
                    color: getColor(isPasswordLongEnough, colors),
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
                  color: getColor(isPasswordComplexEnough, colors),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  "Password must contain one uppercase letter, one number, and one special character",
                  style: TextStyle(
                    color: getColor(isPasswordComplexEnough, colors),
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
