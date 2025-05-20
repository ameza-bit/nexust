import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/widgets/home/sidebar_navigation.dart';

class WebScaffold extends StatelessWidget {
  const WebScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final isWebLayout = context.isWeb;

    Widget scaffoldBody = Scaffold(
      appBar: isWebLayout ? null : appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );

    if (!isWebLayout) return scaffoldBody;

    return Scaffold(
      appBar: AppBar(title: const Text('Web Scaffold')),
      body: Row(
        children: [
          SidebarNavigation(),

          Flexible(
            child: Container(
              margin: EdgeInsets.all(context.contentPadding),
              decoration: BoxDecoration(
                color: context.cardBackground,
                borderRadius: BorderRadius.circular(AppBorderRadius.card),
                boxShadow: [
                  BoxShadow(
                    color:
                        context.isDarkMode
                            ? Colors.black.withAlpha(25)
                            : Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
