import 'package:flutter/material.dart';
import 'package:nexust/main.dart' show navigatorKey;

class Toast {
  static show(String message, {int duration = 5, Color? backgroundColor}) {
    if (message.isEmpty || navigatorKey.currentContext == null) return;

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message, maxLines: 5),
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
