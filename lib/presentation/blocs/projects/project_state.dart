import 'package:equatable/equatable.dart';
import 'package:nexust/data/enums/project_status.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/data/models/project_member.dart';

class ProjectState extends Equatable {
  final List<Project> projects;
  final Project? currentProject;
  final List<ProjectMember> currentProjectMembers;
  final ProjectStatus status;
  final String? errorMessage;
  final bool isInitialized;

  const ProjectState({
    this.projects = const [],
    this.currentProject,
    this.currentProjectMembers = const [],
    this.status = ProjectStatus.initial,
    this.errorMessage,
    this.isInitialized = false,
  });

  ProjectState copyWith({
    List<Project>? projects,
    Project? currentProject,
    List<ProjectMember>? currentProjectMembers,
    ProjectStatus? status,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      currentProject: currentProject ?? this.currentProject,
      currentProjectMembers:
          currentProjectMembers ?? this.currentProjectMembers,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
    projects,
    currentProject,
    currentProjectMembers,
    status,
    errorMessage,
    isInitialized,
  ];
}
