import 'package:flutter/material.dart';

@immutable
class GlobalColors extends ThemeExtension<GlobalColors> {
  final Color secondaryTextColor;
  final Color accentColor;
  final Color successColor;
  final Color errorColor;

  const GlobalColors({
    required this.secondaryTextColor,
    required this.accentColor,
    required this.successColor,
    required this.errorColor,
  });

  @override
  ThemeExtension<GlobalColors> copyWith({
    Color? secondaryTextColor,
    Color? accentColor,
    Color? successColor,
    Color? errorColor,
  }) {
    return GlobalColors(
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      accentColor: accentColor ?? this.accentColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }

  @override
  ThemeExtension<GlobalColors> lerp(GlobalColors? other, double t) {
    if (other is! GlobalColors) {
      return this;
    }

    return GlobalColors(
      secondaryTextColor:
          Color.lerp(secondaryTextColor, other.secondaryTextColor, t) ??
              secondaryTextColor,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
      successColor:
          Color.lerp(successColor, other.successColor, t) ?? successColor,
      errorColor: Color.lerp(errorColor, other.errorColor, t) ?? errorColor,
    );
  }
}
