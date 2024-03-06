import 'package:flutter/material.dart';
import 'package:password_manager/services/passwords/password.dart';

class SinglePasswordPage extends StatefulWidget {
  final Password? password;

  const SinglePasswordPage({super.key, this.password});

  @override
  State<SinglePasswordPage> createState() => _SinglePasswordPageState();
}

class _SinglePasswordPageState extends State<SinglePasswordPage> {
  @override
  Widget build(BuildContext context) {
    final title = widget.password == null ? 'Add Password' : 'Edit Password';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Column(
        children: [
          //
        ],
      ),
    );
  }
}
