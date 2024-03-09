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
    extensions: const [
      GlobalColors(
        secondaryTextColor: lightSecondaryTextColor,
        toastColor: lightToastColor,
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
      checkColor: MaterialStateColor.resolveWith((_) => Colors.white),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateColor.resolveWith((_) => Colors.white),
    ),
    extensions: const [
      GlobalColors(
        secondaryTextColor: darkSecondaryTextColor,
        toastColor: darkToastColor,
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
