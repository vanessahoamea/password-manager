import 'package:flutter/material.dart';
import 'package:password_manager/utils/theme_extensions/input_field_colors.dart';

class SecondaryInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final bool? isObscured;
  final void Function()? toggleVisibility;

  const SecondaryInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.isObscured,
    this.toggleVisibility,
  });

  @override
  State<SecondaryInputField> createState() => _SecondaryInputFieldState();
}

class _SecondaryInputFieldState extends State<SecondaryInputField> {
  void _copyToClipboard() {
    //
  }

  @override
  Widget build(BuildContext context) {
    final InputFieldColors colors =
        Theme.of(context).extension<InputFieldColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: colors.backgroundColor,
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: colors.textColor),
          border: InputBorder.none,
          suffixIcon: widget.obscureText && widget.isObscured != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: widget.toggleVisibility,
                      icon: Icon(
                        widget.isObscured!
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: colors.textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyToClipboard(),
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                )
              : IconButton(
                  onPressed: () => _copyToClipboard(),
                  icon: const Icon(Icons.copy),
                ),
        ),
        obscureText: widget.isObscured ?? false,
      ),
    );
  }
}
