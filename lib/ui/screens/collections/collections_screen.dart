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
        automaticallyImplyLeading: false,
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
          (context) => SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    endpoint.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  if (endpoint.isGroup)
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
                          _showCreateEndpointDialog(
                            context,
                            parentId: endpoint.id,
                          );
                        }
                      },
                    ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.lightArrowRightArrowLeft),
                    title: Text("Mover a..."),
                    onTap: () {
                      Navigator.pop(context);
                      _showMoveEndpointDialog(context, endpoint);
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
                    leading: Icon(
                      FontAwesomeIcons.lightTrash,
                      color: Colors.red,
                    ),
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
    final collectionsState = context.read<CollectionsCubit>().state;

    showDialog(
      context: context,
      builder:
          (context) => CreateEndpointDialog(
            initialParentId: parentId,
            collections: collectionsState.collections,
            onSave: (name, method, path, selectedParentId) {
              final newEndpoint = RestEndpoint(
                name: name,
                isGroup: false,
                method: method,
                path: path,
              );
              // Usamos el parentId seleccionado en el diálogo
              context
                  .read<CollectionsCubit>()
                  .addCollection(newEndpoint, parentId: selectedParentId)
                  .then((_) {
                    // Navegar a la pantalla de detalle de endpoint
                    if (context.mounted) {
                      context.pushNamed(
                        RequestScreen.routeName,
                        pathParameters: {'requestUuid': newEndpoint.id},
                        extra: {'endpoint': newEndpoint},
                      );
                    }
                  });
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
    final collectionsState = context.read<CollectionsCubit>().state;
    String? currentParentId = _findParentId(
      collectionsState.collections,
      endpoint.id,
    );

    showDialog(
      context: context,
      builder:
          (context) => CreateEndpointDialog(
            initialName: endpoint.name,
            initialMethod: endpoint.method,
            initialPath: endpoint.path,
            initialParentId: currentParentId,
            collections: collectionsState.collections,
            onSave: (name, method, path, selectedParentId) {
              // Primero actualizamos el endpoint con los datos básicos
              final updatedEndpoint = endpoint.copyWith(
                name: name,
                method: method,
                path: path,
              );

              // Si cambió la carpeta, necesitamos moverlo
              if (currentParentId != selectedParentId) {
                // Primero actualizamos el endpoint
                context.read<CollectionsCubit>().updateCollection(
                  updatedEndpoint,
                );

                // Luego lo movemos a la nueva carpeta
                context.read<CollectionsCubit>().moveCollection(
                  endpoint.id,
                  selectedParentId,
                );
              } else {
                // Solo actualizamos si no cambió la carpeta
                context.read<CollectionsCubit>().updateCollection(
                  updatedEndpoint,
                );
              }
            },
          ),
    );
  }

  // Función auxiliar para encontrar la carpeta padre de un endpoint
  String? _findParentId(List<RestEndpoint> collections, String endpointId) {
    for (var collection in collections) {
      // Verificar si el endpoint está en esta colección
      if (collection.children.any((child) => child.id == endpointId)) {
        return collection.id;
      }

      // Buscar recursivamente en los hijos
      if (collection.isGroup && collection.children.isNotEmpty) {
        final foundId = _findParentId(collection.children, endpointId);
        if (foundId != null) {
          return foundId;
        }
      }
    }

    // Si no se encuentra en ninguna carpeta, está en la raíz
    return null;
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

void _showMoveEndpointDialog(BuildContext context, RestEndpoint endpoint) {
  final collectionsState = context.read<CollectionsCubit>().state;
  String? selectedFolderId;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Función para construir los items del dropdown
          List<DropdownMenuItem<String?>> buildDropdownItems() {
            final items = [
              DropdownMenuItem<String?>(value: null, child: Text("Raíz")),
            ];

            void addCollectionItems(List<RestEndpoint> collections, int depth) {
              for (var collection in collections) {
                if (collection.isGroup && collection.id != endpoint.id) {
                  // No mostrar la carpeta actual para evitar ciclos
                  items.add(
                    DropdownMenuItem<String?>(
                      value: collection.id,
                      child: Padding(
                        padding: EdgeInsets.only(left: depth * 16.0),
                        child: Text(collection.name),
                      ),
                    ),
                  );

                  if (collection.children.isNotEmpty) {
                    addCollectionItems(collection.children, depth + 1);
                  }
                }
              }
            }

            addCollectionItems(collectionsState.collections, 0);
            return items;
          }

          return AlertDialog(
            title: Text("Mover ${endpoint.name}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Seleccionar carpeta de destino:"),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black12
                            : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      isExpanded: true,
                      value: selectedFolderId,
                      hint: Text("Seleccionar carpeta"),
                      onChanged: (String? value) {
                        setState(() {
                          selectedFolderId = value;
                        });
                      },
                      items: buildDropdownItems(),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(context.tr('common.cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implementar la función de mover en el CollectionsCubit
                  context.read<CollectionsCubit>().moveCollection(
                    endpoint.id,
                    selectedFolderId,
                  );
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text("Mover"),
              ),
            ],
          );
        },
      );
    },
  );
}
