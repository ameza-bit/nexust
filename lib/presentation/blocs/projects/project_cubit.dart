import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/enums/project_role.dart';
import 'package:nexust/data/enums/project_status.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/data/models/project_member.dart';
import 'package:nexust/domain/repositories/project_member_repository.dart';
import 'package:nexust/domain/repositories/project_repository.dart';
import 'package:nexust/presentation/blocs/projects/project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectRepository _projectRepository;
  final ProjectMemberRepository _memberRepository;

  ProjectCubit(this._projectRepository, this._memberRepository)
    : super(const ProjectState());

  Future<void> initialize() async {
    if (state.isInitialized) return;

    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      // Cargar todos los proyectos
      final projects = await _projectRepository.getProjects();

      // Obtener el proyecto actual o usar el personal si no hay ninguno
      Project? currentProject = await _projectRepository.getCurrentProject();

      // Si no hay proyecto actual o el usuario no es miembro, usar el personal
      if (currentProject == null ||
          !(await _memberRepository.isUserMemberOfProject(
            FirebaseAuth.instance.currentUser?.uid ?? '',
            currentProject.id,
          ))) {
        // Buscar proyecto personal del usuario
        currentProject = projects.firstWhereOrNull(
          (p) =>
              p.isPersonal &&
              p.ownerId == FirebaseAuth.instance.currentUser?.uid,
        );

        // Si no tiene proyecto personal, crearlo
        if (currentProject == null) {
          currentProject = await _projectRepository.createPersonalProject(
            FirebaseAuth.instance.currentUser?.uid ?? '',
            FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario',
          );
          projects.add(currentProject);
        }

        // Guardar el proyecto actual
        await _projectRepository.setCurrentProject(currentProject.id);
      }

      // Cargar miembros del proyecto actual
      final members = await _memberRepository.getProjectMembers(
        currentProject.id,
      );

      emit(
        state.copyWith(
          projects: projects,
          currentProject: currentProject,
          currentProjectMembers: members,
          status: ProjectStatus.success,
          isInitialized: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> loadProjects() async {
    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      final projects = await _projectRepository.getProjects();
      emit(state.copyWith(projects: projects, status: ProjectStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> createProject(String name, String description) async {
    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      final project = Project(
        name: name,
        description: description,
        ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
      );

      final createdProject = await _projectRepository.createProject(project);

      // Añadir el creador como propietario
      final ownerMember = ProjectMember(
        projectId: createdProject.id,
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        role: ProjectRole.owner,
      );

      await _memberRepository.addMember(ownerMember);

      // Actualizar la lista de proyectos
      final projects = List<Project>.of(state.projects)..add(createdProject);

      emit(state.copyWith(projects: projects, status: ProjectStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateProject(Project project) async {
    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      await _projectRepository.updateProject(project);

      // Actualizar la lista de proyectos
      final projects =
          state.projects.map((p) => p.id == project.id ? project : p).toList();

      // Actualizar el proyecto actual si es el mismo
      final updatedCurrentProject =
          state.currentProject?.id == project.id
              ? project
              : state.currentProject;

      emit(
        state.copyWith(
          projects: projects,
          currentProject: updatedCurrentProject,
          status: ProjectStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteProject(String projectId) async {
    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      await _projectRepository.deleteProject(projectId);

      // Actualizar la lista de proyectos
      final projects = state.projects.where((p) => p.id != projectId).toList();

      // Si el proyecto eliminado era el actual, actualizar el proyecto actual
      Project? updatedCurrentProject = state.currentProject;
      if (state.currentProject?.id == projectId) {
        updatedCurrentProject = await _projectRepository.getCurrentProject();

        // Cargar miembros del nuevo proyecto actual
        final List<ProjectMember> members =
            updatedCurrentProject != null
                ? await _memberRepository.getProjectMembers(
                  updatedCurrentProject.id,
                )
                : [];

        emit(
          state.copyWith(
            projects: projects,
            currentProject: updatedCurrentProject,
            currentProjectMembers: members,
            status: ProjectStatus.success,
          ),
        );
      } else {
        emit(state.copyWith(projects: projects, status: ProjectStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> switchProject(String projectId) async {
    if (state.currentProject?.id == projectId) return;

    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      // Guardar el proyecto actual
      await _projectRepository.setCurrentProject(projectId);

      // Obtener el proyecto completo
      final project = await _projectRepository.getProjectById(projectId);
      if (project != null) {
        // Cargar miembros del proyecto
        final members = await _memberRepository.getProjectMembers(projectId);

        emit(
          state.copyWith(
            currentProject: project,
            currentProjectMembers: members,
            status: ProjectStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProjectStatus.error,
            errorMessage: 'Proyecto no encontrado',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addMember(String email, ProjectRole role) async {
    if (state.currentProject == null) {
      emit(
        state.copyWith(
          status: ProjectStatus.error,
          errorMessage: 'No hay un proyecto seleccionado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      // Validación simple del email
      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }

      // Crear la membresía
      // En una app real, enviaríamos una invitación y
      // asociaríamos el ID de usuario cuando acepte
      final member = ProjectMember(
        projectId: state.currentProject!.id,
        userId: 'pending_${DateTime.now().millisecondsSinceEpoch}', // Temporal
        email: email,
        role: role,
      );

      await _memberRepository.addMember(member);

      // Actualizar miembros del proyecto actual
      final members = await _memberRepository.getProjectMembers(
        state.currentProject!.id,
      );

      emit(
        state.copyWith(
          currentProjectMembers: members,
          status: ProjectStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateMember(ProjectMember member) async {
    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      await _memberRepository.updateMember(member);

      // Actualizar miembros del proyecto actual
      final members =
          state.currentProjectMembers
              .map((m) => m.id == member.id ? member : m)
              .toList();

      emit(
        state.copyWith(
          currentProjectMembers: members,
          status: ProjectStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> removeMember(String memberId) async {
    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      await _memberRepository.removeMember(memberId);

      // Actualizar miembros del proyecto actual
      final members =
          state.currentProjectMembers.where((m) => m.id != memberId).toList();

      emit(
        state.copyWith(
          currentProjectMembers: members,
          status: ProjectStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProjectStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
