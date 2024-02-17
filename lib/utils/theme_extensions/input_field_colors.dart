import 'package:flutter/material.dart';

@immutable
class InputFieldColors extends ThemeExtension<InputFieldColors> {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const InputFieldColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  ThemeExtension<InputFieldColors> copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
  }) {
    return InputFieldColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  ThemeExtension<InputFieldColors> lerp(InputFieldColors? other, double t) {
    if (other is! InputFieldColors) {
      return this;
    }

    return InputFieldColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
    );
  }
}
