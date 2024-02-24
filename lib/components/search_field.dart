import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/input_field_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final InputFieldColors colors =
        Theme.of(context).extension<InputFieldColors>()!;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderColor),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: colors.backgroundColor,
        hintText: 'Search',
        hintStyle: TextStyle(color: colors.textColor),
        prefixIcon: Icon(Icons.search, color: colors.textColor),
      ),
      onChanged: onChanged,
    );
  }
}
