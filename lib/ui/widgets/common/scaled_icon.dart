import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';

class ScaledIcon extends StatelessWidget {
  final IconData icon;
  final double? baseSize;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final List<Shadow>? shadows;

  const ScaledIcon(
    this.icon, {
    super.key,
    this.baseSize = 24.0,
    this.color,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: context.scaleIcon(baseSize!),
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      shadows: shadows,
    );
  }
}
