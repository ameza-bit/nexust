import 'package:nexust/data/models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project?> getProjectById(String id);
  Future<List<Project>> getProjectsByUser(String userId);
  Future<Project> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
  Future<Project> createPersonalProject(String userId, String userName);
  Future<Project?> getCurrentProject();
  Future<void> setCurrentProject(String projectId);
}
