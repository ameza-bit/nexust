import 'package:flutter/material.dart';
import 'package:nexust/presentation/widgets/home/sidebar_navigation.dart';

class CollapsibleSidebar extends StatefulWidget {
  const CollapsibleSidebar({super.key, required this.controller});

  final TabController controller;

  @override
  State<CollapsibleSidebar> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar> {
  bool _isExpanded = true;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Navegación
        SidebarNavigation(
          controller: widget.controller,
          isExpanded: _isExpanded,
        ),

        // Botón para expandir/colapsar
        Positioned(
          right: 0,
          top: 80,
          child: GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              width: 24,
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
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
