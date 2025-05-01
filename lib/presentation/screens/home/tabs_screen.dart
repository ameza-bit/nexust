import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nexust/presentation/screens/collections/collections_screen.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/screens/more/more_screen.dart';
import 'package:nexust/presentation/screens/request/request_screen.dart';
import 'package:nexust/presentation/widgets/home/navigator_bar.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = "tabs";
  const TabsScreen({super.key, this.initialIndex});

  final int? initialIndex;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex ?? 0,
    );
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
            HomeScreen(),
            CollectionsScreen(),
            RequestScreen(),
            MoreScreen(),
          ],
        ),
        bottomNavigationBar: NavigatorBar(controller: _tabController),
      ),
    );
  }
}
