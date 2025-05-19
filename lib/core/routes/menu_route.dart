import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/models/menu_item.dart';
import 'package:nexust/main.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';

class MenuRoute {
  final BuildContext context;
  const MenuRoute(this.context);

  List<MenuItem> get tabsItems => [
    MenuItem(
      label: context.tr('navigation.home'),
      icon: FontAwesomeIcons.lightHouseChimney,
      route: _getPathRoute(
        HomeScreen.routeName,
        queryParameters: {"mainTabIndex": "0"},
      ),
    ),
    MenuItem(
      label: context.tr('navigation.collections'),
      icon: FontAwesomeIcons.lightRectangleHistory,
      route: _getPathRoute(
        HomeScreen.routeName,
        queryParameters: {"mainTabIndex": "1"},
      ),
    ),
    MenuItem(
      label: context.tr('navigation.quick_request'),
      icon: FontAwesomeIcons.lightEnvelopeOpenText,
      route: _getPathRoute(
        HomeScreen.routeName,
        queryParameters: {"mainTabIndex": "2"},
      ),
    ),
    MenuItem(
      label: context.tr('navigation.more'),
      icon: FontAwesomeIcons.lightBars,
      route: _getPathRoute(
        HomeScreen.routeName,
        queryParameters: {"mainTabIndex": "3"},
      ),
      showInWeb: false,
    ),
  ];

  List<MenuItem> get menuItems => [];

  static _getPathRoute(
    String pathName, {
    Map<String, String> queryParameters = const {},
  }) {
    return GoRouter.of(navigatorKey.currentContext!)
        .routeInformationParser
        .configuration
        .namedLocation(pathName, queryParameters: queryParameters);
  }
}
