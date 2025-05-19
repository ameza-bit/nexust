import 'package:flutter/material.dart';

class MenuItem {
  final String label;
  final String subLabel;
  final IconData icon;
  final String route;
  final bool showInWeb;

  const MenuItem({
    required this.label,
    this.subLabel = '',
    required this.icon,
    required this.route,
    this.showInWeb = true,
  });
}
