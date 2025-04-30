// lib/ui/views/collections/collection_list_view.dart (modificado)
import 'package:flutter/material.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/ui/widgets/collections/rest_endpoint_item.dart';

class CollectionListView extends StatelessWidget {
  final List<RestEndpoint> items;
  final Function(RestEndpoint) onItemTap;
  final Function(RestEndpoint, BuildContext) onItemLongPress;

  const CollectionListView({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return RestEndpointItem(
          endpoint: items[index],
          depth: 0,
          onTap: () => onItemTap(items[index]),
          onLongPress: () => onItemLongPress(items[index], context),
        );
      },
    );
  }
}
