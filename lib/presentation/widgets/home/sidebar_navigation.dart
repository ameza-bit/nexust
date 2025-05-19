import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({
    super.key,
    required this.controller,
    this.isExpanded = true, // Para soportar versión colapsada si se desea
  });

  final TabController controller;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = context.scaleIcon(22.0);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: isExpanded ? 240 : 80, // Ancho adaptable
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Logo y nombre de la app
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/icon.png', height: 40),
                if (isExpanded) SizedBox(width: 16),
                if (isExpanded)
                  Text(
                    'Nexust',
                    style: TextStyle(
                      fontSize: context.scaleText(20),
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
              ],
            ),
          ),

          Divider(color: context.divider),
          const SizedBox(height: 16),

          // Elementos de navegación
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context,
                  0,
                  FontAwesomeIcons.lightHouseChimney,
                  context.tr("navigation.home"),
                  iconSize,
                ),
                _buildNavItem(
                  context,
                  1,
                  FontAwesomeIcons.lightRectangleHistory,
                  context.tr("navigation.collections"),
                  iconSize,
                ),
                _buildNavItem(
                  context,
                  2,
                  FontAwesomeIcons.lightEnvelopeOpenText,
                  context.tr("navigation.quick_request"),
                  iconSize,
                ),
                _buildNavItem(
                  context,
                  3,
                  FontAwesomeIcons.lightBars,
                  context.tr("navigation.more"),
                  iconSize,
                ),
              ],
            ),
          ),

          // Se podría añadir perfil u opciones adicionales aquí
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    double iconSize,
  ) {
    final isSelected = controller.index == index;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => controller.animateTo(index),
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
          children: [
            FaIcon(
              icon,
              size: iconSize,
              color: isSelected ? theme.primaryColor : context.textSecondary,
            ),
            if (isExpanded) const SizedBox(width: 16),
            if (isExpanded)
              Text(
                label,
                style: TextStyle(
                  fontSize: context.scaleText(16),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.primaryColor : context.textPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
