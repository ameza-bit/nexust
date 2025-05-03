import 'dart:convert';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/project_role.dart';
import 'package:nexust/data/models/project_member.dart';
import 'package:nexust/domain/repositories/project_member_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectMemberRepositoryImpl implements ProjectMemberRepository {
  static const String _membersKey = 'project_members';

  @override
  Future<List<ProjectMember>> getProjectMembers(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final membersJson = prefs.getString(_membersKey);

    if (membersJson == null) {
      return [];
    }

    try {
      final List<Object?> decoded = List<Object?>.from(
        jsonDecode(membersJson) as List,
      );

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => ProjectMember.fromJson(item))
          .where((member) => member.projectId == projectId)
          .toList();
    } catch (e) {
      Toast.show('Error al cargar miembros del proyecto: $e');
      return [];
    }
  }

  @override
  Future<void> addMember(ProjectMember member) async {
    final members = await _getAllMembers();

    // Evitar duplicar miembros
    if (members.any(
      (m) => m.userId == member.userId && m.projectId == member.projectId,
    )) {
      return;
    }

    members.add(member);
    await _saveAllMembers(members);
  }

  @override
  Future<void> updateMember(ProjectMember member) async {
    final members = await _getAllMembers();
    final index = members.indexWhere((m) => m.id == member.id);

    if (index != -1) {
      members[index] = member;
      await _saveAllMembers(members);
    }
  }

  @override
  Future<void> removeMember(String memberId) async {
    final members = await _getAllMembers();
    members.removeWhere((m) => m.id == memberId);
    await _saveAllMembers(members);
  }

  @override
  Future<bool> isUserMemberOfProject(String userId, String projectId) async {
    final members = await _getAllMembers();
    return members.any((m) => m.userId == userId && m.projectId == projectId);
  }

  @override
  Future<ProjectRole?> getUserRole(String userId, String projectId) async {
    final members = await _getAllMembers();
    final member = members.firstWhere(
      (m) => m.userId == userId && m.projectId == projectId,
      orElse: () => null as ProjectMember,
    );

    return member?.role;
  }

  // Método auxiliar para obtener todos los miembros
  Future<List<ProjectMember>> _getAllMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final membersJson = prefs.getString(_membersKey);

    if (membersJson == null) {
      return [];
    }

    try {
      final List<Object?> decoded = List<Object?>.from(
        jsonDecode(membersJson) as List,
      );

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => ProjectMember.fromJson(item))
          .toList();
    } catch (e) {
      Toast.show('Error al cargar miembros de proyectos: $e');
      return [];
    }
  }

  // Método auxiliar para guardar todos los miembros
  Future<void> _saveAllMembers(List<ProjectMember> members) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(members.map((m) => m.toJson()).toList());
    await prefs.setString(_membersKey, encoded);
  }
}
