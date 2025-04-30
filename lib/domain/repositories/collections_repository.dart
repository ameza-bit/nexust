import 'package:nexust/data/models/rest_endpoint.dart';

abstract class CollectionsRepository {
  Future<List<RestEndpoint>> getCollections();
  Future<void> saveCollections(List<RestEndpoint> collections);
  Future<void> addCollection(RestEndpoint collection);
  Future<void> updateCollection(RestEndpoint collection);
  Future<void> deleteCollection(String id);
  Future<List<RestEndpoint>> searchCollections(String query);
}
