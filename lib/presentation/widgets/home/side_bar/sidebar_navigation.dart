import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/routes/menu_route.dart';
import 'package:nexust/presentation/blocs/sidebar/side_bar_cubit.dart';
import 'package:nexust/presentation/blocs/sidebar/side_bar_state.dart';
import 'package:nexust/presentation/widgets/home/side_bar/side_bar_item.dart';

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key});

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Hero(
      tag: 'web_sidebar',
      transitionOnUserGestures: true,
      child: BlocBuilder<SideBarCubit, SideBarState>(
        builder: (context, state) {
          return Container(
            width: state.sideBar.isExpanded ? 240 : 80 + context.scaleIcon(5),
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
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
                // Elementos de navegación
                GestureDetector(
                  onTap:
                      () => context.read<SideBarCubit>().toggleSideBarState(),
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
                      state.sideBar.isExpanded
                          ? Icons.chevron_left
                          : Icons.chevron_right,
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
                      ...MenuRoute(context).tabItems
                          .where((item) => item.showInWeb)
                          .map((item) => SideBarItem(item: item)),
                      const SizedBox(height: 8),
                      Divider(color: context.divider),
                      const SizedBox(height: 8),
                      ...MenuRoute(context).menuItems
                          .where((item) => item.showInWeb)
                          .map((item) => SideBarItem(item: item)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
