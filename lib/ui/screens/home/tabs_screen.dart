import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nexust/ui/widgets/home/navigation_bar.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = "tabs";
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (_tabController.index == 0) exit(0);
      },
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: Text("Tab 1")),
            Center(child: Text("Tab 2")),
            Center(child: Text("Tab 3")),
            Center(child: Text("Tab 4")),
          ],
        ),
        bottomNavigationBar: NavigatorBar(controller: _tabController),
      ),
    );
  }
}
