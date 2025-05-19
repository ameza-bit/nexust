import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/routes/menu_route.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key, this.controller});
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = context.scaleIcon(22.0);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha(40)
                    : Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: TabBar(
          controller: controller,
          labelColor: isDark ? Colors.white : Colors.black,
          unselectedLabelColor:
              isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.scaleText(12.0),
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.scaleText(12.0),
          ),
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.primaryColor, width: 3),
            ),
          ),
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.only(top: 8),
          tabs:
              MenuRoute(context).tabsItems
                  .map(
                    (item) => Tab(
                      text: item.label,
                      icon: FaIcon(item.icon, size: iconSize),
                      iconMargin: EdgeInsets.only(bottom: 4),
                      height: 65,
                    ),
                  )
                  .toList(),
          onTap: (value) {
            context.goNamed(
              HomeScreen.routeName,
              queryParameters: {"mainTabIndex": value.toString()},
            );
          },
        ),
      ),
    );
  }
}
