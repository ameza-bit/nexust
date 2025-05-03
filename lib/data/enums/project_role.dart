enum ProjectRole { owner, admin, editor, viewer }

extension ProjectRoleExtension on ProjectRole {
  String get name {
    switch (this) {
      case ProjectRole.owner:
        return 'owner';
      case ProjectRole.admin:
        return 'admin';
      case ProjectRole.editor:
        return 'editor';
      case ProjectRole.viewer:
        return 'viewer';
    }
  }

  static ProjectRole fromString(String name) {
    switch (name) {
      case 'owner':
        return ProjectRole.owner;
      case 'admin':
        return ProjectRole.admin;
      case 'editor':
        return ProjectRole.editor;
      case 'viewer':
        return ProjectRole.viewer;
      default:
        return ProjectRole.viewer;
    }
  }
}
