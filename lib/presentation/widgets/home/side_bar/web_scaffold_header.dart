import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/presentation/blocs/sidebar/side_bar_cubit.dart';
import 'package:nexust/presentation/blocs/sidebar/side_bar_state.dart';

class WebScaffoldHeader extends StatelessWidget implements PreferredSizeWidget {
  const WebScaffoldHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.cardColor,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: BlocBuilder<SideBarCubit, SideBarState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: [
                Image.asset('assets/images/icon.png', height: 40),
                if (state.sideBar.isExpanded) const SizedBox(width: 16),
                if (state.sideBar.isExpanded)
                  Flexible(
                    child: Text(
                      'Nexust',
                      style: TextStyle(
                        fontSize: context.scaleText(20),
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
