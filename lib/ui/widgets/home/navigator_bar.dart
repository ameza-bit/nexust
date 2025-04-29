import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key, this.controller});
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
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
          tabs: [
            Tab(
              text: context.tr("navigation.home"),
              icon: FaIcon(FontAwesomeIcons.lightHouseChimney, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              height: 65,
            ),
            Tab(
              text: context.tr("navigation.collections"),
              icon: FaIcon(FontAwesomeIcons.lightRectangleHistory, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              height: 65,
            ),
            Tab(
              text: context.tr("navigation.quick_request"),
              icon: FaIcon(FontAwesomeIcons.lightEnvelopeOpenText, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              height: 65,
            ),
            Tab(
              text: context.tr("navigation.more"),
              icon: FaIcon(FontAwesomeIcons.lightBars, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              height: 65,
            ),
          ],
        ),
      ),
    );
  }
}
