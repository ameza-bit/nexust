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

class _CollectionTreeItemState extends State<CollectionTreeItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: widget.entity.isDirectory ? widget.onTap : null,
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.depth * 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Icon(
                  widget.entity.isDirectory
                      ? (widget.entity.isExpanded
                          ? Icons.folder_open
                          : Icons.folder)
                      : Icons.insert_drive_file,
                  color:
                      widget.entity.isDirectory
                          ? Colors.amber
                          : Colors.blueGrey,
                ),
                SizedBox(width: 8.0),
                Text(widget.entity.name),
                if (widget.entity.isDirectory)
                  Icon(
                    widget.entity.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 16.0,
                  ),
              ],
            ),
          ),
        ),
        if (widget.entity.isDirectory && widget.entity.isExpanded)
          Column(
            children:
                widget.entity.children.map((child) {
                  return CollectionTreeItem(
                    entity: child,
                    depth: widget.depth + 1,
                    onTap: () {
                      setState(() {
                        child.isExpanded = !child.isExpanded;
                      });
                    },
                  );
                }).toList(),
          ),
      ],
    );
  }
}
