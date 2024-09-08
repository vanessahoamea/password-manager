import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossPlatformSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const CrossPlatformSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Switch(
            value: value,
            onChanged: onChanged,
          )
        : CupertinoSwitch(
            value: value,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: onChanged,
          );
  }
}
