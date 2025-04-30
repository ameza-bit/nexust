// lib/presentation/blocs/collections/collections_cubit.dart (modificado)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/domain/repositories/collections_repository.dart';
import 'package:nexust/presentation/blocs/collections/collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  final CollectionsRepository _collectionsRepository;

  CollectionsCubit(this._collectionsRepository)
    : super(CollectionsState.initial()) {
    loadCollections();
  }

  Future<void> loadCollections() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final collections = await _collectionsRepository.getCollections();
      emit(
        state.copyWith(
          collections: collections,
          filteredCollections: collections,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> addCollection(
    RestEndpoint collection, {
    String? parentId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      if (parentId == null) {
        // Agregar a nivel raíz
        final updatedCollections = List<RestEndpoint>.of(state.collections)
          ..add(collection);
        await _collectionsRepository.saveCollections(updatedCollections);
      } else {
        // Agregar como hijo de una colección existente
        final updatedCollections = _addChildToCollection(
          state.collections,
          parentId,
          collection,
        );
        await _collectionsRepository.saveCollections(updatedCollections);
      }
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> updateCollection(RestEndpoint collection) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedCollections = _updateCollectionInList(
        state.collections,
        collection,
      );
      await _collectionsRepository.saveCollections(updatedCollections);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteCollection(String id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedCollections = _removeCollectionFromList(
        state.collections,
        id,
      );
      await _collectionsRepository.saveCollections(updatedCollections);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> duplicateCollection(RestEndpoint collection) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final duplicate = collection.duplicate();
      final updatedCollections = List<RestEndpoint>.of(state.collections)
        ..add(duplicate);
      await _collectionsRepository.saveCollections(updatedCollections);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> searchCollections(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));
    try {
      if (query.isEmpty) {
        emit(
          state.copyWith(
            filteredCollections: state.collections,
            isLoading: false,
          ),
        );
      } else {
        final filteredCollections = _filterCollections(
          state.collections,
          query.toLowerCase(),
        );
        emit(
          state.copyWith(
            filteredCollections: filteredCollections,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  // Método para actualizar la vista expandida/colapsada
  void toggleExpanded(String id) {
    final updatedCollections = _updateExpandedState(state.collections, id);

    emit(
      state.copyWith(
        collections: updatedCollections,
        filteredCollections:
            state.searchQuery.isEmpty
                ? updatedCollections
                : _updateExpandedState(state.filteredCollections, id),
      ),
    );

    // Guardar el estado expandido
    _collectionsRepository.saveCollections(updatedCollections);
  }

  // Función recursiva para filtrar colecciones por query
  List<RestEndpoint> _filterCollections(
    List<RestEndpoint> collections,
    String query,
  ) {
    List<RestEndpoint> result = [];

    for (var collection in collections) {
      if (collection.name.toLowerCase().contains(query) ||
          (!collection.isGroup &&
              collection.path.toLowerCase().contains(query))) {
        result.add(collection);
      } else if (collection.isGroup) {
        // Buscar en los hijos
        final filteredChildren = _filterCollections(collection.children, query);
        if (filteredChildren.isNotEmpty) {
          // Si hay hijos que coinciden, incluir la colección padre
          result.add(collection.copyWith(children: filteredChildren));
        }
      }
    }

    return result;
  }

  // Función recursiva para actualizar el estado expandido
  List<RestEndpoint> _updateExpandedState(List<RestEndpoint> items, String id) {
    return items.map((item) {
      if (item.id == id) {
        return item.copyWith(isExpanded: !item.isExpanded);
      } else if (item.isGroup) {
        return item.copyWith(children: _updateExpandedState(item.children, id));
      }
      return item;
    }).toList();
  }

  // Función recursiva para añadir un hijo a una colección
  List<RestEndpoint> _addChildToCollection(
    List<RestEndpoint> items,
    String parentId,
    RestEndpoint newChild,
  ) {
    return items.map((item) {
      if (item.id == parentId && item.isGroup) {
        // Añadir el hijo a la colección
        final updatedChildren = List<RestEndpoint>.of(item.children)
          ..add(newChild);
        return item.copyWith(children: updatedChildren);
      } else if (item.isGroup) {
        // Buscar recursivamente en los hijos
        return item.copyWith(
          children: _addChildToCollection(item.children, parentId, newChild),
        );
      }
      return item;
    }).toList();
  }

  // Función recursiva para actualizar una colección
  List<RestEndpoint> _updateCollectionInList(
    List<RestEndpoint> items,
    RestEndpoint updatedItem,
  ) {
    return items.map((item) {
      if (item.id == updatedItem.id) {
        return updatedItem;
      } else if (item.isGroup) {
        // Buscar recursivamente en los hijos
        return item.copyWith(
          children: _updateCollectionInList(item.children, updatedItem),
        );
      }
      return item;
    }).toList();
  }

  // Función recursiva para eliminar una colección
  List<RestEndpoint> _removeCollectionFromList(
    List<RestEndpoint> items,
    String id,
  ) {
    // Primero, verificar si el elemento está a nivel raíz
    if (items.any((item) => item.id == id)) {
      return items.where((item) => item.id != id).toList();
    }

    // Si no está a nivel raíz, buscar en los hijos
    return items.map((item) {
      if (item.isGroup) {
        // Verificar si algún hijo directo tiene el ID a eliminar
        if (item.children.any((child) => child.id == id)) {
          return item.copyWith(
            children: item.children.where((child) => child.id != id).toList(),
          );
        }

        // Buscar recursivamente en los hijos
        return item.copyWith(
          children: _removeCollectionFromList(item.children, id),
        );
      }
      return item;
    }).toList();
  }
}
