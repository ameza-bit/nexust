import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key, required this.controller});

  final TabController controller;

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.controller.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = context.scaleIcon(20.0);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: _isExpanded ? 240 : 80 + context.scaleIcon(5), // Ancho adaptable
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
                if (_isExpanded) SizedBox(width: 16),
                if (_isExpanded)
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
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Icon(
                _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                color: Colors.white,
                size: context.scaleIcon(24),
              ),
            ),
          ),

          const SizedBox(height: 16),

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
    final isSelected = widget.controller.index == index;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => widget.controller.animateTo(index),
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
              _isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: iconSize,
              color: isSelected ? theme.primaryColor : context.textSecondary,
            ),
            if (_isExpanded) ...[
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
