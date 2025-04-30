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
    emit(state.copyWith(isLoading: true));
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

  Future<void> addCollection(RestEndpoint collection) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _collectionsRepository.addCollection(collection);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> updateCollection(RestEndpoint collection) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _collectionsRepository.updateCollection(collection);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteCollection(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _collectionsRepository.deleteCollection(id);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> duplicateCollection(RestEndpoint collection) async {
    emit(state.copyWith(isLoading: true));
    try {
      final duplicate = collection.duplicate();
      await _collectionsRepository.addCollection(duplicate);
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
        final results = await _collectionsRepository.searchCollections(query);
        emit(state.copyWith(filteredCollections: results, isLoading: false));
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
  }

  // Función recursiva para actualizar el estado expandido
  List<RestEndpoint> _updateExpandedState(List<RestEndpoint> items, String id) {
    return items.map((item) {
      if (item.id == id) {
        return item.copyWith(isExpanded: !item.isExpanded);
      } else if (item.isGroup && item.children.isNotEmpty) {
        return item.copyWith(children: _updateExpandedState(item.children, id));
      } else {
        return item;
      }
    }).toList();
  }
}
