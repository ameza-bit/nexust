import 'package:nexust/data/enums/project_role.dart';
import 'package:uuid/uuid.dart';

class ProjectMember {
  final String id;
  final String projectId;
  final String userId;
  final String email;
  final ProjectRole role;
  final DateTime addedAt;

  ProjectMember({
    String? id,
    required this.projectId,
    required this.userId,
    required this.email,
    this.role = ProjectRole.viewer,
    DateTime? addedAt,
  }) : id = id ?? const Uuid().v4(),
       addedAt = addedAt ?? DateTime.now();

  ProjectMember copyWith({
    String? id,
    String? projectId,
    String? userId,
    String? email,
    ProjectRole? role,
    DateTime? addedAt,
  }) {
    return ProjectMember(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'userId': userId,
      'email': email,
      'role': role.name,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'],
      projectId: json['projectId'],
      userId: json['userId'],
      email: json['email'],
      role: ProjectRoleExtension.fromString(json['role']),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}
