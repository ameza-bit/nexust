import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/models/menu_item.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/screens/home/redirect_screen.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem({super.key, required this.isExpanded, required this.item});

  final bool isExpanded;
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = context.scaleIcon(20.0);

    final state = GoRouterState.of(context);
    final path = state.uri.path;
    final mainIndex = state.uri.queryParameters['mainTabIndex'] ?? '0';

    final uriItemRoute = Uri.parse(item.route);
    final isMainScreen =
        path == '/${HomeScreen.routeName}' && path == uriItemRoute.path;
    final itemMainIndex = uriItemRoute.queryParameters['mainTabIndex'] ?? '0';

    final isSelected = isMainScreen && mainIndex == itemMainIndex;

    return InkWell(
      onTap:
          () => context.goNamed(
            RedirectScreen.routeName,
            queryParameters: {'redirect_route': item.route},
          ),
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
              item.icon,
              size: iconSize,
              color: isSelected ? theme.primaryColor : context.textSecondary,
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Text(
                item.label,
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
