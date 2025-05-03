import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/data/services/firestore_service.dart';
import 'package:nexust/domain/repositories/project_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  static const String _projectsKey = 'projects';
  static const String _currentProjectKey = 'current_project';

  final FirestoreService _firestoreService;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _projectsSubscription;
  List<Project> _cachedProjects = [];
  bool _isInitialized = false;

  ProjectRepositoryImpl({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService() {
    // Iniciar escucha a cambios en Firestore cuando se crea el repositorio
    _initFirestoreSubscription();
  }

  // Inicializar la suscripción a Firestore
  void _initFirestoreSubscription() {
    _projectsSubscription?.cancel();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _projectsSubscription = _firestoreService
        .streamUserProjects(user.uid)
        .listen(
          (snapshot) async {
            // Sólo procesar si ya tenemos datos en caché
            if (_isInitialized) {
              await _handleFirestoreChanges(snapshot);
            }
          },
          onError: (error) {
            debugPrint('Error en stream de proyectos: $error');
          },
        );
  }

  // Procesar cambios de Firestore y actualizar caché local
  Future<void> _handleFirestoreChanges(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    final List<Project> firestoreProjects = [];

    for (var doc in snapshot.docs) {
      try {
        final projectData = doc.data();
        // Asegurarnos que el ID del documento coincide con el ID del proyecto
        final project = Project.fromJson({...projectData, 'id': doc.id});
        firestoreProjects.add(project);
      } catch (e) {
        debugPrint('Error al convertir documento a Project: $e');
      }
    }

    // Sincronizar con proyectos locales
    _mergeProjects(firestoreProjects);
  }

  // Fusionar proyectos de Firestore con proyectos locales
  Future<void> _mergeProjects(List<Project> firestoreProjects) async {
    // Obtener los proyectos locales
    final localProjects = await _getLocalProjects();
    final mergedProjects = <Project>[];

    // 1. Agregar proyectos que existen en ambos (preferir la versión de Firestore)
    for (var localProject in localProjects) {
      final firestoreProject = firestoreProjects.firstWhereOrNull(
        (p) => p.id == localProject.id,
      );

      if (firestoreProject != null) {
        // El proyecto existe en ambos lugares, usar Firestore
        mergedProjects.add(firestoreProject);
      } else {
        // El proyecto solo existe localmente
        if (localProject.isPersonal) {
          // Si es un proyecto personal local, verificar si hay uno en Firestore
          final personalInFirestore = firestoreProjects.firstWhereOrNull(
            (p) => p.isPersonal && p.ownerId == localProject.ownerId,
          );

          if (personalInFirestore != null) {
            // Ya existe un proyecto personal en Firestore, usar ese
            continue;
          }

          // Es un proyecto personal que no está en Firestore, enviarlo
          mergedProjects.add(localProject);
          await _saveProjectToFirestore(localProject);
        } else {
          // Proyecto normal que solo existe localmente, agregarlo y sincronizar
          mergedProjects.add(localProject);
          await _saveProjectToFirestore(localProject);
        }
      }
    }

    // 2. Agregar proyectos que solo existen en Firestore
    for (var firestoreProject in firestoreProjects) {
      final exists = mergedProjects.any((p) => p.id == firestoreProject.id);
      if (!exists) {
        mergedProjects.add(firestoreProject);
      }
    }

    // 3. Actualizar caché y guardar localmente
    _cachedProjects = mergedProjects;
    await _saveLocalProjects(mergedProjects);
  }

  // Guardar un proyecto a Firestore
  Future<void> _saveProjectToFirestore(Project project) async {
    try {
      await _firestoreService.saveProject(project.id, project.toJson());
    } catch (e) {
      debugPrint('Error al guardar proyecto en Firestore: $e');
      // No propagamos el error para permitir operación offline
    }
  }

  // Eliminar un proyecto de Firestore
  Future<void> _deleteProjectFromFirestore(String projectId) async {
    try {
      await _firestoreService.deleteProject(projectId);
    } catch (e) {
      debugPrint('Error al eliminar proyecto en Firestore: $e');
      // No propagamos el error para permitir operación offline
    }
  }

  // Obtener proyectos desde SharedPreferences
  Future<List<Project>> _getLocalProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString(_projectsKey);

    if (projectsJson == null) {
      return [];
    }

    try {
      final List<Object?> decoded = List<Object?>.from(
        jsonDecode(projectsJson) as List,
      );

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => Project.fromJson(item))
          .toList();
    } catch (e) {
      Toast.show('Error al cargar proyectos: $e');
      return [];
    }
  }

  // Guardar proyectos en SharedPreferences
  Future<void> _saveLocalProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString(_projectsKey, encoded);
  }

  @override
  Future<List<Project>> getProjects() async {
    // Si ya tenemos los proyectos en caché, devolverlos inmediatamente
    if (_isInitialized && _cachedProjects.isNotEmpty) {
      return _cachedProjects;
    }

    // Cargar desde almacenamiento local
    final localProjects = await _getLocalProjects();
    _cachedProjects = localProjects;
    _isInitialized = true;

    // Intentar sincronizar con Firestore en segundo plano
    _syncProjectsWithFirestore();

    return localProjects;
  }

  // Sincronizar proyectos con Firestore
  Future<void> _syncProjectsWithFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Verificar si hay conexión a internet
      if (await _firestoreService.hasInternetConnection()) {
        // Obtener proyectos del usuario desde Firestore
        final firestoreDocs = await _firestoreService.getUserProjects(user.uid);

        final firestoreProjects =
            firestoreDocs
                .map(
                  (doc) => Project.fromJson({
                    ...doc.data(),
                    'id': doc.id, // Asegurar que el ID coincide
                  }),
                )
                .toList();

        await _mergeProjects(firestoreProjects);
      }
    } catch (e) {
      debugPrint('Error al sincronizar con Firestore: $e');
      // No propagamos el error para permitir operación offline
    }
  }

  @override
  Future<Project?> getProjectById(String id) async {
    // Primero buscar en caché
    if (_isInitialized) {
      final cachedProject = _cachedProjects.firstWhereOrNull((p) => p.id == id);
      if (cachedProject != null) {
        return cachedProject;
      }
    }

    // Si no está en caché, buscar en almacenamiento local
    final projects = await getProjects();
    return projects.firstWhereOrNull((p) => p.id == id);
  }

  @override
  Future<List<Project>> getProjectsByUser(String userId) async {
    final projects = await getProjects();
    return projects.where((p) => p.ownerId == userId).toList();
  }

  @override
  Future<Project> createProject(Project project) async {
    final projects = await getProjects();

    // Evitar duplicados por ID
    if (projects.any((p) => p.id == project.id)) {
      return project;
    }

    // Agregar a la lista local
    projects.add(project);
    _cachedProjects = projects;
    await _saveLocalProjects(projects);

    // Sincronizar con Firestore
    await _saveProjectToFirestore(project);

    return project;
  }

  @override
  Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);

    if (index != -1) {
      projects[index] = project;
      _cachedProjects = projects;
      await _saveLocalProjects(projects);

      // Sincronizar con Firestore
      await _saveProjectToFirestore(project);
    }
  }

  @override
  Future<void> deleteProject(String id) async {
    final projects = await getProjects();

    // Verificar si es un proyecto personal
    final projectToDelete = projects.firstWhereOrNull((p) => p.id == id);

    if (projectToDelete != null && projectToDelete.isPersonal) {
      throw Exception('No se puede eliminar el proyecto personal');
    }

    projects.removeWhere((p) => p.id == id);
    _cachedProjects = projects;
    await _saveLocalProjects(projects);

    // Sincronizar eliminación con Firestore
    await _deleteProjectFromFirestore(id);

    // Si el proyecto eliminado era el actual, cambiar al proyecto personal
    final current = await getCurrentProject();
    if (current?.id == id) {
      final personalProject = projects.firstWhereOrNull(
        (p) =>
            p.isPersonal && p.ownerId == FirebaseAuth.instance.currentUser?.uid,
      );

      if (personalProject != null) {
        await setCurrentProject(personalProject.id);
      }
    }
  }

  @override
  Future<Project> createPersonalProject(String userId, String userName) async {
    // Verificar si hay un proyecto personal en Firestore primero
    final firestorePersonalProject = await _findPersonalProjectInFirestore(
      userId,
    );
    if (firestorePersonalProject != null) {
      // Ya existe en Firestore, agregar a local si no está
      final projects = await getProjects();
      if (!projects.any((p) => p.id == firestorePersonalProject.id)) {
        projects.add(firestorePersonalProject);
        _cachedProjects = projects;
        await _saveLocalProjects(projects);
      }
      return firestorePersonalProject;
    }

    // Si no existe en Firestore, verificar en la caché local
    final projects = await getProjects();
    final existingPersonal = projects.firstWhereOrNull(
      (p) => p.isPersonal && p.ownerId == userId,
    );

    if (existingPersonal != null) {
      // Existe localmente, sincronizar con Firestore
      await _saveProjectToFirestore(existingPersonal);
      return existingPersonal;
    }

    // Crear nuevo proyecto personal solo si no existe en ningún lado
    final personalProject = Project(
      name: 'Proyecto Personal',
      description: 'Proyecto personal de $userName',
      ownerId: userId,
      isPersonal: true,
    );

    await createProject(personalProject);

    // Si es el primer proyecto del usuario, establecerlo como actual
    if (projects.isEmpty) {
      await setCurrentProject(personalProject.id);
    }

    return personalProject;
  }

  // Buscar un proyecto personal en Firestore
  Future<Project?> _findPersonalProjectInFirestore(String userId) async {
    try {
      final personalProject = await _firestoreService.findPersonalProject(
        userId,
      );
      if (personalProject != null) {
        return Project.fromJson({
          ...personalProject.data()!,
          'id': personalProject.id,
        });
      }
      return null;
    } catch (e) {
      debugPrint('Error buscando proyecto personal: $e');
      return null;
    }
  }

  @override
  Future<Project?> getCurrentProject() async {
    final prefs = await SharedPreferences.getInstance();
    final currentProjectId = prefs.getString(_currentProjectKey);

    if (currentProjectId == null) {
      return null;
    }

    return getProjectById(currentProjectId);
  }

  @override
  Future<void> setCurrentProject(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentProjectKey, projectId);
  }

  // Método para limpiar recursos al destruir el repositorio
  void dispose() {
    _projectsSubscription?.cancel();
  }
}
