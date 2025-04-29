import 'package:flutter/material.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/models/rest_endpoint.dart';

class RestEndpointItem extends StatefulWidget {
  const RestEndpointItem({
    super.key,
    required this.endpoint,
    required this.depth,
    required this.onTap,
  });

  final RestEndpoint endpoint;
  final int depth;
  final VoidCallback onTap;

  @override
  State<RestEndpointItem> createState() => _RestEndpointItemState();
}

class _RestEndpointItemState extends State<RestEndpointItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.endpoint.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RestEndpointItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.endpoint.isExpanded != oldWidget.endpoint.isExpanded) {
      if (widget.endpoint.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getMethodColor() {
    if (widget.endpoint.isGroup) {
      return widget.endpoint.isExpanded ? Color(0xFF5C6BC0) : Color(0xFF7986CB);
    } else {
      // Asignar colores según método HTTP
      return widget.endpoint.method.color;
    }
  }

  IconData _getMethodIcon() {
    if (widget.endpoint.isGroup) {
      return widget.endpoint.isExpanded
          ? FontAwesomeIcons.folderOpen
          : FontAwesomeIcons.folder;
    } else {
      // Iconos específicos para cada método HTTP
      return widget.endpoint.method.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // Línea vertical que muestra la jerarquía
            if (widget.depth > 0)
              Container(
                width: 2,
                color: (isDark ? Colors.grey.shade700 : Colors.grey).withAlpha(
                  76,
                ),
                margin: EdgeInsets.only(left: widget.depth * 20.0 - 10),
              ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: widget.depth * 15.0,
                      right: 10.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.endpoint.isGroup
                              ? (widget.endpoint.isExpanded
                                  ? _getMethodColor().withAlpha(
                                    isDark ? 50 : 25,
                                  )
                                  : Colors.transparent)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getMethodColor().withAlpha(isDark ? 100 : 76),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icono del método HTTP o grupo
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getMethodColor().withAlpha(
                              isDark ? 50 : 25,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FaIcon(
                            _getMethodIcon(),
                            color: _getMethodColor(),
                            size: 18.0,
                          ),
                        ),
                        SizedBox(width: 12.0),
                        // Nombre del endpoint o grupo
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.endpoint.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!widget.endpoint.isGroup &&
                                  widget.endpoint.path.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getMethodColor(),
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        child: Text(
                                          widget.endpoint.method.stringName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6.0),
                                      Expanded(
                                        child: Text(
                                          widget.endpoint.path,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                isDark
                                                    ? Colors.grey.shade400
                                                    : Colors.grey.shade600,
                                            fontFamily: 'monospace',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (widget.endpoint.isGroup)
                          RotationTransition(
                            turns: _rotationAnimation,
                            child: FaIcon(
                              widget.endpoint.isExpanded
                                  ? FontAwesomeIcons.chevronDown
                                  : FontAwesomeIcons.chevronRight,
                              color:
                                  isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                              size: 18.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Contenedor para los elementos hijos con animación
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Column(
            children:
                widget.endpoint.isGroup
                    ? widget.endpoint.children.map((child) {
                      return RestEndpointItem(
                        endpoint: child,
                        depth: widget.depth + 1,
                        onTap: () {
                          setState(() {
                            child.isExpanded = !child.isExpanded;
                          });
                        },
                      );
                    }).toList()
                    : [],
          ),
          crossFadeState:
              widget.endpoint.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
