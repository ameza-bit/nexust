import 'package:flutter/material.dart';
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
  bool _showDetails = false;

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
      final method = widget.endpoint.method.toUpperCase();
      switch (method) {
        case 'GET':
          return Color(0xFF4CAF50); // Verde para GET
        case 'POST':
          return Color(0xFF2196F3); // Azul para POST
        case 'PUT':
          return Color(0xFFFF9800); // Naranja para PUT
        case 'PATCH':
          return Color(0xFF9C27B0); // Púrpura para PATCH
        case 'DELETE':
          return Color(0xFFF44336); // Rojo para DELETE
        case 'OPTIONS':
          return Color(0xFF607D8B); // Azul grisáceo para OPTIONS
        case 'HEAD':
          return Color(0xFF795548); // Marrón para HEAD
        default:
          return Color(0xFF78909C); // Gris azulado para otros
      }
    }
  }

  IconData _getMethodIcon() {
    if (widget.endpoint.isGroup) {
      return widget.endpoint.isExpanded ? Icons.api_rounded : Icons.api_rounded;
    } else {
      // Iconos específicos para cada método HTTP
      final method = widget.endpoint.method.toUpperCase();
      switch (method) {
        case 'GET':
          return Icons.download_rounded;
        case 'POST':
          return Icons.add_circle_outline_rounded;
        case 'PUT':
          return Icons.edit_rounded;
        case 'PATCH':
          return Icons.sync_rounded;
        case 'DELETE':
          return Icons.delete_outline_rounded;
        case 'OPTIONS':
          return Icons.settings_rounded;
        case 'HEAD':
          return Icons.info_outline_rounded;
        default:
          return Icons.http_rounded;
      }
    }
  }

  Widget _buildDetailsSection() {
    if (!_showDetails || widget.endpoint.isGroup) return Container();

    return Container(
      margin: EdgeInsets.only(
        left: widget.depth * 20.0 + 46.0,
        right: 10.0,
        top: 4.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.endpoint.path.isNotEmpty) ...[
            Text(
              'Ruta:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              widget.endpoint.path,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14.0,
                color: Colors.grey.shade900,
              ),
            ),
            SizedBox(height: 8.0),
          ],

          if (widget.endpoint.parameters != null &&
              widget.endpoint.parameters!.isNotEmpty) ...[
            Text(
              'Parámetros:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4.0),
            _buildJsonPreview(widget.endpoint.parameters),
            SizedBox(height: 8.0),
          ],

          if (widget.endpoint.headers != null &&
              widget.endpoint.headers!.isNotEmpty) ...[
            Text(
              'Headers:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4.0),
            _buildJsonPreview(widget.endpoint.headers),
            SizedBox(height: 8.0),
          ],

          if (widget.endpoint.body != null) ...[
            Text(
              'Body:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4.0),
            _buildJsonPreview(widget.endpoint.body),
            SizedBox(height: 8.0),
          ],

          if (widget.endpoint.response != null) ...[
            Text(
              'Respuesta:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4.0),
            _buildJsonPreview(widget.endpoint.response),
          ],
        ],
      ),
    );
  }

  Widget _buildJsonPreview(dynamic json) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        json.toString(),
        style: TextStyle(fontFamily: 'monospace', fontSize: 13.0),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Línea vertical que muestra la jerarquía
        if (widget.depth > 0)
          Container(
            width: 2,
            height: 10,
            color: Colors.grey.withOpacity(0.3),
            margin: EdgeInsets.only(left: widget.depth * 20.0 - 10),
          ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: EdgeInsets.only(
                left: widget.depth * 20.0,
                right: 10.0,
                top: 4.0,
                bottom: 4.0,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color:
                    widget.endpoint.isGroup
                        ? (widget.endpoint.isExpanded
                            ? _getMethodColor().withOpacity(0.1)
                            : Colors.transparent)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getMethodColor().withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Icono del método HTTP o grupo
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getMethodColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getMethodIcon(),
                      color: _getMethodColor(),
                      size: 24.0,
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
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    widget.endpoint.method.toUpperCase(),
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
                                      color: Colors.grey.shade600,
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
                  // Botón para ver detalles (solo endpoints)
                  if (!widget.endpoint.isGroup)
                    IconButton(
                      icon: Icon(
                        _showDetails ? Icons.visibility_off : Icons.visibility,
                        size: 20.0,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                    ),
                  // Icono de flecha para grupos
                  if (widget.endpoint.isGroup)
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey.shade600,
                        size: 24.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        // Sección de detalles
        _buildDetailsSection(),
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
