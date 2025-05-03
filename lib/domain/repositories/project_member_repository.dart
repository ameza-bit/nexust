import 'package:nexust/data/enums/project_role.dart';
import 'package:nexust/data/models/project_member.dart';

abstract class ProjectMemberRepository {
  Future<List<ProjectMember>> getProjectMembers(String projectId);
  Future<void> addMember(ProjectMember member);
  Future<void> updateMember(ProjectMember member);
  Future<void> removeMember(String memberId);
  Future<bool> isUserMemberOfProject(String userId, String projectId);
  Future<ProjectRole?> getUserRole(String userId, String projectId);
}
