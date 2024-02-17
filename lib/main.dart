import 'package:flutter/material.dart';
import 'package:password_manager/pages/login.dart';
import 'package:password_manager/utils/themes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Password Manager',
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.system,
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
