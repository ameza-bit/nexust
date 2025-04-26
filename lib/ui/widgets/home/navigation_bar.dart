import 'package:flutter/material.dart';
import 'package:nexust/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/ui/theme/neutral_theme.dart';

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key, this.controller});
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: NeutralTheme.offWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: NeutralTheme.richBlack.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: TabBar(
          controller: controller,
          labelColor: NeutralTheme.oilBlack,
          unselectedLabelColor: NeutralTheme.grey06,
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
              top: BorderSide(color: NeutralTheme.oilBlack, width: 3),
            ),
          ),
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.only(top: 8),
          tabs: [
            const Tab(
              text: "Inicio",
              icon: FaIcon(FontAwesomeIcons.lightHouseChimney, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              height: 65,
            ),
            const Tab(
              text: "Colecciones",
              icon: FaIcon(FontAwesomeIcons.lightRectangleHistory, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              height: 65,
            ),
            const Tab(
              icon: FaIcon(FontAwesomeIcons.lightEnvelopeOpenText, size: 22),
              iconMargin: EdgeInsets.only(bottom: 4),
              text: "Petición\nRápida",
              height: 65,
            ),
            const Tab(
              text: "Más",
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
