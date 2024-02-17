import 'package:flutter/material.dart';
import 'package:password_manager/extensions/dark_mode.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const PrimaryButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: context.isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
