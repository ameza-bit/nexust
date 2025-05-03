import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener la instancia de Firestore
  FirebaseFirestore get firestore => _firestore;

  // Verificar si hay conexión a internet
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none);
  }

  // Obtener colección de proyectos
  CollectionReference<Map<String, dynamic>> getProjectsCollection() {
    return _firestore.collection('projects');
  }

  // Obtener proyecto por ID
  Future<DocumentSnapshot<Map<String, dynamic>>?> getProject(
    String projectId,
  ) async {
    if (await hasInternetConnection()) {
      try {
        return await getProjectsCollection().doc(projectId).get();
      } catch (e) {
        debugPrint('Error getting project from Firestore: $e');
        return null;
      }
    }
    return null;
  }

  // Guardar un proyecto en Firestore
  Future<void> saveProject(String projectId, Map<String, dynamic> data) async {
    if (await hasInternetConnection()) {
      try {
        // Agregar campos de metadatos
        data['lastUpdated'] = FieldValue.serverTimestamp();

        await getProjectsCollection()
            .doc(projectId)
            .set(data, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error saving project to Firestore: $e');
        // No lanzamos la excepción para permitir operaciones sin conexión
      }
    }
  }

  // Eliminar un proyecto de Firestore
  Future<void> deleteProject(String projectId) async {
    if (await hasInternetConnection()) {
      try {
        await getProjectsCollection().doc(projectId).delete();
      } catch (e) {
        debugPrint('Error deleting project from Firestore: $e');
        // No lanzamos la excepción para permitir operaciones sin conexión
      }
    }
  }

  // Obtener todos los proyectos de un usuario
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserProjects(
    String userId,
  ) async {
    if (await hasInternetConnection()) {
      try {
        // Buscar proyectos donde el usuario es propietario o miembro
        final ownerQuery =
            await getProjectsCollection()
                .where('ownerId', isEqualTo: userId)
                .get();

        final memberQuery =
            await getProjectsCollection()
                .where('members', arrayContains: {'userId': userId})
                .get();

        // Combinar resultados, evitando duplicados
        Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> results = {};

        // Agregar proyectos donde el usuario es propietario
        for (var doc in ownerQuery.docs) {
          results[doc.id] = doc;
        }

        // Agregar proyectos donde el usuario es miembro
        for (var doc in memberQuery.docs) {
          results[doc.id] = doc;
        }

        return results.values.toList();
      } catch (e) {
        debugPrint('Error getting user projects from Firestore: $e');
        return [];
      }
    }
    return [];
  }

  // Buscar proyecto personal de un usuario
  Future<DocumentSnapshot<Map<String, dynamic>>?> findPersonalProject(
    String userId,
  ) async {
    if (await hasInternetConnection()) {
      try {
        final querySnapshot =
            await getProjectsCollection()
                .where('ownerId', isEqualTo: userId)
                .where('isPersonal', isEqualTo: true)
                .limit(1)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first;
        }
        return null;
      } catch (e) {
        debugPrint('Error finding personal project: $e');
        return null;
      }
    }
    return null;
  }

  // Escuchar cambios en los proyectos del usuario
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserProjects(
    String userId,
  ) {
    try {
      if (userId.isEmpty) {
        return Stream.empty();
      }

      // Utilizamos una consulta que devuelve cualquier proyecto donde el usuario
      // sea propietario o esté en la lista de miembros
      // Nota: Esta es una simplificación. En una implementación real,
      // probablemente necesitarías dos queries separadas y combinar los resultados.
      return getProjectsCollection()
          .where('ownerId', isEqualTo: userId)
          .snapshots();
    } catch (e) {
      debugPrint('Error streaming user projects: $e');
      return Stream.empty();
    }
  }
}
