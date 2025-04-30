import 'dart:convert';

import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/domain/repositories/collections_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  static const String _collectionsKey = 'rest_collections';

  @override
  Future<List<RestEndpoint>> getCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final collectionsJson = prefs.getString(_collectionsKey);

    if (collectionsJson == null) {
      return [];
    }

    try {
      final List<Object?> decoded = List<Object?>.from(
        jsonDecode(collectionsJson) as List,
      );

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => RestEndpoint.fromJson(item))
          .toList();
    } catch (e) {
      Toast.show('Error al cargar colecciones: $e');
      return [];
    }
  }

  @override
  Future<void> saveCollections(List<RestEndpoint> collections) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(collections.map((c) => c.toJson()).toList());
    await prefs.setString(_collectionsKey, encoded);
  }

  @override
  Future<void> addCollection(RestEndpoint collection) async {
    final collections = await getCollections();
    collections.add(collection);
    await saveCollections(collections);
  }

  @override
  Future<void> updateCollection(RestEndpoint collection) async {
    final collections = await getCollections();
    final index = collections.indexWhere((c) => c.id == collection.id);

    if (index != -1) {
      collections[index] = collection;
      await saveCollections(collections);
    }
  }

  @override
  Future<void> deleteCollection(String id) async {
    final collections = await getCollections();
    collections.removeWhere((c) => c.id == id);
    await saveCollections(collections);
  }

  @override
  Future<List<RestEndpoint>> searchCollections(String query) async {
    if (query.isEmpty) {
      return getCollections();
    }

    final collections = await getCollections();
    final results = <RestEndpoint>[];

    for (var collection in collections) {
      if (_matches(collection, query.toLowerCase())) {
        results.add(collection);
      }
    }

    return results;
  }

  // Función recursiva para buscar en colecciones y sus hijos
  bool _matches(RestEndpoint endpoint, String query) {
    // Verificar si el nombre o la ruta contienen la consulta
    if (endpoint.name.toLowerCase().contains(query) ||
        endpoint.path.toLowerCase().contains(query)) {
      return true;
    }

    // Si es un grupo, buscar en los hijos
    if (endpoint.isGroup && endpoint.children.isNotEmpty) {
      for (var child in endpoint.children) {
        if (_matches(child, query)) {
          return true;
        }
      }
    }

    return false;
  }
}
