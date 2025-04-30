// lib/ui/screens/collections/collections_screen.dart (modificado)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/presentation/blocs/collections/collections_cubit.dart';
import 'package:nexust/presentation/blocs/collections/collections_state.dart';
import 'package:nexust/ui/screens/request/request_screen.dart';
import 'package:nexust/ui/views/collections/collection_list_view.dart';
import 'package:nexust/ui/widgets/collections/create_collection_dialog.dart';
import 'package:nexust/ui/widgets/collections/create_endpoint_dialog.dart';

class CollectionsScreen extends StatefulWidget {
  static const String routeName = "collections";
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: context.tr('collections.search'),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(fontSize: 16.0),
                  autofocus: true,
                  onChanged: (query) {
                    context.read<CollectionsCubit>().searchCollections(query);
                  },
                )
                : Text(
                  context.tr('navigation.collections'),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  context.read<CollectionsCubit>().searchCollections('');
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(FontAwesomeIcons.lightEllipsisVertical),
            onSelected: (value) {
              if (value == 'new_collection') {
                _showCreateCollectionDialog(context);
              } else if (value == 'new_endpoint') {
                _showCreateEndpointDialog(context);
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'new_collection',
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.lightFolder, size: 16),
                        SizedBox(width: 8),
                        Text(context.tr('collections.new_collection')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'new_endpoint',
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.lightCode, size: 16),
                        SizedBox(width: 8),
                        Text(context.tr('collections.new_endpoint')),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CollectionsCubit, CollectionsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.filteredCollections.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              state.searchQuery.isNotEmpty
                                  ? FontAwesomeIcons.lightFolderMinus
                                  : FontAwesomeIcons.lightFolderPlus,
                              size: 64,
                              color: Colors.grey.withAlpha(128),
                            ),
                            SizedBox(height: 16),
                            Text(
                              state.searchQuery.isNotEmpty
                                  ? context.tr('collections.no_results')
                                  : context.tr('collections.no_collections'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16),
                            if (state.searchQuery.isEmpty)
                              ElevatedButton.icon(
                                onPressed:
                                    () => _showCreateCollectionDialog(context),
                                icon: Icon(FontAwesomeIcons.lightPlus),
                                label: Text(
                                  context.tr('collections.create_first'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: CollectionListView(
                      items: state.filteredCollections,
                      onItemTap: _handleItemTap,
                      onItemLongPress: _showItemOptions,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOptionsDialog(context),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        tooltip: context.tr('collections.new_item'),
        child: Icon(FontAwesomeIcons.lightPlus),
      ),
    );
  }

  void _handleItemTap(RestEndpoint endpoint) {
    if (endpoint.isGroup) {
      context.read<CollectionsCubit>().toggleExpanded(endpoint.id);
    } else {
      // Navegar a la pantalla de detalle de endpoint usando GoRouter
      context.pushNamed(
        RequestScreen.routeName,
        pathParameters: {'requestUuid': endpoint.id},
        extra: {'endpoint': endpoint},
      );
    }
  }

  void _showItemOptions(RestEndpoint endpoint, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  endpoint.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    endpoint.isGroup
                        ? FontAwesomeIcons.lightFolderPlus
                        : FontAwesomeIcons.lightFilePlus,
                  ),
                  title: Text(context.tr('collections.add_child')),
                  onTap: () {
                    Navigator.pop(context);
                    if (endpoint.isGroup) {
                      _showCreateEndpointDialog(context, parentId: endpoint.id);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightPenToSquare),
                  title: Text(context.tr('collections.edit')),
                  onTap: () {
                    Navigator.pop(context);
                    if (endpoint.isGroup) {
                      _showEditCollectionDialog(context, endpoint);
                    } else {
                      _showEditEndpointDialog(context, endpoint);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightCopy),
                  title: Text(context.tr('collections.duplicate')),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<CollectionsCubit>().duplicateCollection(
                      endpoint,
                    );
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightTrash, color: Colors.red),
                  title: Text(
                    context.tr('collections.delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, endpoint);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showCreateOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: Text(context.tr('collections.create_new')),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _showCreateCollectionDialog(context);
                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.lightFolder),
                    SizedBox(width: 16),
                    Text(context.tr('collections.new_collection')),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _showCreateEndpointDialog(context);
                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.lightCode),
                    SizedBox(width: 16),
                    Text(context.tr('collections.new_endpoint')),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => CreateCollectionDialog(
            onSave: (name) {
              final newCollection = RestEndpoint(
                name: name,
                isGroup: true,
                children: [],
              );
              context.read<CollectionsCubit>().addCollection(newCollection);
            },
          ),
    );
  }

  void _showCreateEndpointDialog(BuildContext context, {String? parentId}) {
    showDialog(
      context: context,
      builder:
          (context) => CreateEndpointDialog(
            onSave: (name, method, path) {
              final newEndpoint = RestEndpoint(
                name: name,
                isGroup: false,
                method: method,
                path: path,
              );
              context.read<CollectionsCubit>().addCollection(newEndpoint);
            },
          ),
    );
  }

  void _showEditCollectionDialog(
    BuildContext context,
    RestEndpoint collection,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => CreateCollectionDialog(
            initialName: collection.name,
            onSave: (name) {
              final updatedCollection = collection.copyWith(name: name);
              context.read<CollectionsCubit>().updateCollection(
                updatedCollection,
              );
            },
          ),
    );
  }

  void _showEditEndpointDialog(BuildContext context, RestEndpoint endpoint) {
    showDialog(
      context: context,
      builder:
          (context) => CreateEndpointDialog(
            initialName: endpoint.name,
            initialMethod: endpoint.method,
            initialPath: endpoint.path,
            onSave: (name, method, path) {
              final updatedEndpoint = endpoint.copyWith(
                name: name,
                method: method,
                path: path,
              );
              context.read<CollectionsCubit>().updateCollection(
                updatedEndpoint,
              );
            },
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, RestEndpoint endpoint) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('collections.delete_confirm_title')),
            content: Text(
              endpoint.isGroup
                  ? context.tr(
                    'collections.delete_collection_confirm',
                    namedArgs: {'name': endpoint.name},
                  )
                  : context.tr(
                    'collections.delete_endpoint_confirm',
                    namedArgs: {'name': endpoint.name},
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<CollectionsCubit>().deleteCollection(
                    endpoint.id,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(context.tr('common.delete')),
              ),
            ],
          ),
    );
  }
}
