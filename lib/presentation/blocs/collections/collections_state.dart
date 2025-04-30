import 'package:equatable/equatable.dart';
import 'package:nexust/data/models/rest_endpoint.dart';

class CollectionsState extends Equatable {
  final List<RestEndpoint> collections;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final List<RestEndpoint> filteredCollections;

  const CollectionsState({
    this.collections = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.filteredCollections = const [],
  });

  factory CollectionsState.initial() {
    return const CollectionsState();
  }

  CollectionsState copyWith({
    List<RestEndpoint>? collections,
    bool? isLoading,
    String? error,
    String? searchQuery,
    List<RestEndpoint>? filteredCollections,
  }) {
    return CollectionsState(
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredCollections: filteredCollections ?? this.filteredCollections,
    );
  }

  @override
  List<Object?> get props => [
    collections,
    isLoading,
    error,
    searchQuery,
    filteredCollections,
  ];
}
