import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' show debugPrint;

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener la instancia de Firestore
  FirebaseFirestore get firestore => _firestore;

  // Verificar si hay conexión a internet
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Obtener colección de proyectos del usuario actual
  CollectionReference<Map<String, dynamic>> getUserProjectsCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('No user is currently signed in');
    }
    return _firestore.collection('users').doc(userId).collection('projects');
  }

  // Guardar un documento en Firestore con id personalizado
  Future<void> setDocument(
    CollectionReference<Map<String, dynamic>> collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    // Verificar conexión a internet antes de intentar guardar
    if (await hasInternetConnection()) {
      try {
        // Agregar campos de metadatos
        data['lastUpdated'] = FieldValue.serverTimestamp();
        await collection.doc(documentId).set(data, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error setting document in Firestore: $e');
        // No lanzamos la excepción para permitir operaciones sin conexión
      }
    }
  }

  // Obtener un documento de Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument(
    CollectionReference<Map<String, dynamic>> collection,
    String documentId,
  ) async {
    if (await hasInternetConnection()) {
      try {
        return await collection.doc(documentId).get();
      } catch (e) {
        debugPrint('Error getting document from Firestore: $e');
        return null;
      }
    }
    return null;
  }

  // Obtener todos los documentos de una colección
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocuments(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    if (await hasInternetConnection()) {
      try {
        QuerySnapshot<Map<String, dynamic>> snapshot = await collection.get();
        return snapshot.docs;
      } catch (e) {
        debugPrint('Error getting documents from Firestore: $e');
        return [];
      }
    }
    return [];
  }

  // Eliminar un documento de Firestore
  Future<void> deleteDocument(
    CollectionReference<Map<String, dynamic>> collection,
    String documentId,
  ) async {
    if (await hasInternetConnection()) {
      try {
        await collection.doc(documentId).delete();
      } catch (e) {
        debugPrint('Error deleting document from Firestore: $e');
        // No lanzamos la excepción para permitir operaciones sin conexión
      }
    }
  }

  // Escuchar cambios en tiempo real en la colección de proyectos
  Stream<QuerySnapshot<Map<String, dynamic>>> streamProjects() {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        // Si no hay usuario, devolvemos un stream vacío
        return Stream.empty();
      }

      // Devolver el stream de los proyectos del usuario
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('projects')
          .snapshots();
    } catch (e) {
      debugPrint('Error streaming projects: $e');
      return Stream.empty();
    }
  }
}
