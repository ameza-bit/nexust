import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem({
    super.key,
    required this.isExpanded,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final bool isExpanded;
  final IconData icon;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = context.scaleIcon(20.0);

    final state = GoRouterState.of(context);
    final path = state.uri.path;
    final mainIndex = state.uri.queryParameters['main_index'] ?? '0';

    // Extraer las partes de la ruta: /home/events -> [home, events]
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    final mainRoute = parts.isNotEmpty ? parts[0] : '';
    final subRoute = parts.length > 1 ? parts[1] : '';

    final isSelected =
        (mainRoute == 'home' && mainIndex == '0' && subRoute == label) ||
            (mainRoute == 'home' && mainIndex == '1' && subRoute == label);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.primaryColor.withAlpha(26)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border:
              isSelected
                  ? Border.all(color: theme.primaryColor, width: 2)
                  : null,
        ),
        child: Row(
          mainAxisAlignment:
              isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: iconSize,
              color: isSelected ? theme.primaryColor : context.textSecondary,
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: context.scaleText(16),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.primaryColor : context.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
