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
import 'package:flutter/foundation.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectRepository _projectRepository;
  final ProjectMemberRepository _memberRepository;
  bool _isSignedIn = false;

  ProjectCubit(this._projectRepository, this._memberRepository)
    : super(const ProjectState()) {
    // Monitorear cambios en el estado de autenticación
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      final wasSignedIn = _isSignedIn;
      _isSignedIn = user != null;

      // Si el estado cambió de no autenticado a autenticado, inicializar
      if (!wasSignedIn && _isSignedIn) {
        initialize();
      }
    });

    // Inicializar inmediatamente si el usuario ya está autenticado
    if (FirebaseAuth.instance.currentUser != null) {
      _isSignedIn = true;
      initialize();
    }
  }

  Future<void> initialize() async {
    if (state.isInitialized) return;

    emit(state.copyWith(status: ProjectStatus.loading));

    try {
      // Cargar todos los proyectos primero para tener la lista completa
      final projects = await _projectRepository.getProjects();

      // Verificar el usuario actual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: ProjectStatus.error,
            errorMessage: 'No hay un usuario autenticado',
          ),
        );
        return;
      }

      // Buscar proyecto personal o crearlo si no existe
      Project personalProject;

      // Buscar entre proyectos existentes
      final existingPersonal = projects.firstWhereOrNull(
        (p) => p.isPersonal && p.ownerId == user.uid,
      );

      if (existingPersonal != null) {
        personalProject = existingPersonal;
      } else {
        // Crear proyecto personal
        personalProject = await _projectRepository.createPersonalProject(
          user.uid,
          user.displayName ?? user.email ?? 'Usuario',
        );

        // Actualizar la lista de proyectos
        projects.add(personalProject);
      }

      // Obtener el proyecto actual
      Project? currentProject = await _projectRepository.getCurrentProject();

      // Si no hay proyecto actual o no pertenece al usuario, usar el personal
      if (currentProject == null ||
          !projects.any((p) => p.id == currentProject!.id)) {
        currentProject = personalProject;
        await _projectRepository.setCurrentProject(personalProject.id);
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
      debugPrint('Error al inicializar ProjectCubit: $e');
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
