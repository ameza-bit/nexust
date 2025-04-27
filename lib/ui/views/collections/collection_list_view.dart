import 'package:flutter/material.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/ui/widgets/collections/rest_endpoint_item.dart';

class CollectionListView extends StatefulWidget {
  const CollectionListView({super.key, required this.items});

  final List<RestEndpoint> items;

  @override
  State<CollectionListView> createState() => _CollectionListViewState();
}

class _CollectionListViewState extends State<CollectionListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return RestEndpointItem(
          endpoint: widget.items[index],
          depth: 0,
          onTap:
              () => setState(
                () =>
                    widget.items[index].isExpanded =
                        !widget.items[index].isExpanded,
              ),
        );
      },
    );
  }
}
