import 'dart:async';

import 'package:flutter/material.dart';
import 'package:password_manager/extensions/dark_mode.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class Toast {
  static OverlayEntry? overlayEntry;
  static Timer? timer;

  static void show({required BuildContext context, required String text}) {
    hide();

    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 75.0,
          right: 75.0,
          bottom: 100.0,
          child: GestureDetector(
            child: Material(
              color: colors.accentColor,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            onTap: () => hide(),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
    timer = Timer(const Duration(seconds: 5), () => hide());
  }

  static void hide() {
    timer?.cancel();
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }
}
