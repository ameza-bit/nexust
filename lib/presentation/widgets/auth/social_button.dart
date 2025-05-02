import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.black12 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 0,
      ),
      icon:
          isLoading
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              )
              : Icon(icon, color: iconColor, size: context.scaleIcon(20)),
      label: Text(
        text,
        style: TextStyle(
          fontSize: context.scaleText(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
