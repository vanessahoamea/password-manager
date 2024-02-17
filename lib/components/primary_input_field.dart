import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/input_field_colors.dart';

class PrimaryInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const PrimaryInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<PrimaryInputField> createState() => _PrimaryInputFieldState();
}

class _PrimaryInputFieldState extends State<PrimaryInputField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final InputFieldColors colors =
        Theme.of(context).extension<InputFieldColors>()!;

    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(20.0),
        filled: true,
        fillColor: colors.backgroundColor,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: colors.textColor),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: toggleVisibility,
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: colors.textColor,
                ),
              )
            : null,
      ),
      obscureText: _isObscured,
    );
  }
}
