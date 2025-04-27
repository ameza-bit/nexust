import 'package:flutter/material.dart';
import 'package:nexust/ui/screens/collections/collections_screen.dart';

class CollectionTreeItem extends StatefulWidget {
  const CollectionTreeItem({
    super.key,
    required this.entity,
    required this.depth,
    required this.onTap,
  });

  final FileSystemEntity entity;
  final int depth;
  final VoidCallback onTap;

  @override
  State<CollectionTreeItem> createState() => _CollectionTreeItemState();
}

class _CollectionTreeItemState extends State<CollectionTreeItem>
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

    if (widget.entity.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CollectionTreeItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entity.isExpanded != oldWidget.entity.isExpanded) {
      if (widget.entity.isExpanded) {
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

  Color _getEntityColor() {
    if (widget.entity.isDirectory) {
      return widget.entity.isExpanded ? Color(0xFFFFA000) : Color(0xFFFFC107);
    } else {
      // Asignar colores según extensión de archivo
      final name = widget.entity.name.toLowerCase();
      if (name.endsWith('.pdf')) return Color(0xFFF44336); // Rojo para PDF
      if (name.endsWith('.docx') || name.endsWith('.doc'))
        return Color(0xFF2196F3); // Azul para Word
      if (name.endsWith('.xlsx') || name.endsWith('.xls'))
        return Color(0xFF4CAF50); // Verde para Excel
      if (name.endsWith('.jpg') ||
          name.endsWith('.png') ||
          name.endsWith('.jpeg'))
        return Color(0xFFE040FB); // Púrpura para imágenes
      return Color(0xFF78909C); // Gris azulado para otros
    }
  }

  IconData _getEntityIcon() {
    if (widget.entity.isDirectory) {
      return widget.entity.isExpanded
          ? Icons.folder_open_rounded
          : Icons.folder_rounded;
    } else {
      final name = widget.entity.name.toLowerCase();
      if (name.endsWith('.pdf')) return Icons.picture_as_pdf_rounded;
      if (name.endsWith('.docx') || name.endsWith('.doc'))
        return Icons.description_rounded;
      if (name.endsWith('.xlsx') || name.endsWith('.xls'))
        return Icons.table_chart_rounded;
      if (name.endsWith('.jpg') ||
          name.endsWith('.png') ||
          name.endsWith('.jpeg'))
        return Icons.image_rounded;
      if (name.endsWith('.txt')) return Icons.text_snippet_rounded;
      return Icons.insert_drive_file_rounded;
    }
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
                    widget.entity.isDirectory
                        ? (widget.entity.isExpanded
                            ? Colors.amber.withOpacity(0.1)
                            : Colors.transparent)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getEntityColor().withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Icono del archivo o carpeta
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getEntityColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getEntityIcon(),
                      color: _getEntityColor(),
                      size: 24.0,
                    ),
                  ),
                  SizedBox(width: 12.0),
                  // Nombre del archivo o carpeta
                  Expanded(
                    child: Text(
                      widget.entity.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight:
                            widget.entity.isDirectory
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Icono de flecha para carpetas
                  if (widget.entity.isDirectory)
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
        // Contenedor para los elementos hijos con animación
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Column(
            children:
                widget.entity.isDirectory
                    ? widget.entity.children.map((child) {
                      return CollectionTreeItem(
                        entity: child,
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
              widget.entity.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
