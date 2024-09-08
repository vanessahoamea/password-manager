import 'package:flutter/material.dart';
import 'package:password_manager/utils/constants.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';
import 'package:password_manager/utils/theme_extensions/input_field_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(primary: primaryColor),
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(color: lightInputFieldTextColor, width: 2.0),
    ),
    sliderTheme: const SliderThemeData(inactiveTrackColor: lightAccentColor),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateColor.resolveWith((_) => Colors.white),
      trackColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return lightAccentColor;
      }),
      trackOutlineColor:
          WidgetStateColor.resolveWith((_) => Colors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0.0),
    ),
    extensions: const [
      GlobalColors(
        secondaryTextColor: lightSecondaryTextColor,
        accentColor: lightAccentColor,
        successColor: lightSuccessColor,
        errorColor: lightErrorColor,
      ),
      InputFieldColors(
        backgroundColor: lightInputFieldBackgroundColor,
        borderColor: lightInputFieldBorderColor,
        textColor: lightInputFieldTextColor,
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(primary: primaryColor),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(color: darkInputFieldTextColor, width: 2.0),
      checkColor: WidgetStateColor.resolveWith((_) => Colors.white),
    ),
    sliderTheme: const SliderThemeData(inactiveTrackColor: darkAccentColor),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateColor.resolveWith((_) => Colors.white),
      trackColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return darkAccentColor;
      }),
      trackOutlineColor:
          WidgetStateColor.resolveWith((_) => Colors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0.0),
    ),
    extensions: const [
      GlobalColors(
        secondaryTextColor: darkSecondaryTextColor,
        accentColor: darkAccentColor,
        successColor: darkSuccessColor,
        errorColor: darkErrorColor,
      ),
      InputFieldColors(
        backgroundColor: darkInputFieldBackgroundColor,
        borderColor: darkInputFieldBorderColor,
        textColor: darkInputFieldTextColor,
      ),
    ],
  );
}
