import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/domain/repositories/project_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  static const String _projectsKey = 'projects';
  static const String _currentProjectKey = 'current_project';

  @override
  Future<List<Project>> getProjects() async {
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

  @override
  Future<Project?> getProjectById(String id) async {
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

    projects.add(project);
    await _saveProjects(projects);
    return project;
  }

  @override
  Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);

    if (index != -1) {
      projects[index] = project;
      await _saveProjects(projects);
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
    await _saveProjects(projects);

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
    final projects = await getProjects();

    // Verificar si ya existe un proyecto personal para este usuario
    final existingPersonal = projects.firstWhereOrNull(
      (p) => p.isPersonal && p.ownerId == userId,
    );

    if (existingPersonal != null) {
      return existingPersonal;
    }

    // Crear nuevo proyecto personal
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

  // Método auxiliar para guardar la lista de proyectos
  Future<void> _saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString(_projectsKey, encoded);
  }
}
