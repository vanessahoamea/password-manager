import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/input_field_colors.dart';

class PrimaryInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool? isObscured;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function()? toggleVisibility;

  const PrimaryInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.isObscured,
    this.initialValue,
    this.onChanged,
    this.toggleVisibility,
  });

  @override
  State<PrimaryInputField> createState() => _PrimaryInputFieldState();
}

class _PrimaryInputFieldState extends State<PrimaryInputField> {
  @override
  void initState() {
    widget.controller.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final InputFieldColors colors =
        Theme.of(context).extension<InputFieldColors>()!;

    return TextField(
      controller: widget.controller,
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
        suffixIcon: widget.obscureText && widget.isObscured != null
            ? IconButton(
                onPressed: widget.toggleVisibility,
                icon: Icon(
                  widget.isObscured! ? Icons.visibility : Icons.visibility_off,
                  color: colors.textColor,
                ),
              )
            : null,
      ),
      obscureText: widget.isObscured ?? false,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
