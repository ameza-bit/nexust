import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/routes/menu_route.dart';
import 'package:nexust/presentation/widgets/home/side_bar_item.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: _isExpanded ? 240 : 80 + context.scaleIcon(5),
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
              children:
                  MenuRoute(context).tabsItems
                      .where((item) => item.showInWeb)
                      .map(
                        (item) =>
                            SideBarItem(isExpanded: _isExpanded, item: item),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
