import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/models/environment.dart';
import 'package:nexust/domain/repositories/environment_repository.dart';
import 'package:nexust/presentation/blocs/environments/environment_state.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';

class EnvironmentCubit extends Cubit<EnvironmentState> {
  final EnvironmentRepository _environmentRepository;
  final ProjectCubit _projectCubit;

  EnvironmentCubit(this._environmentRepository, this._projectCubit)
    : super(const EnvironmentState());

  Future<void> loadEnvironments() async {
    final currentProject = _projectCubit.state.currentProject;
    if (currentProject == null) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: 'No hay un proyecto seleccionado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      final environments = await _environmentRepository.getEnvironments(
        currentProject.id,
      );
      emit(
        state.copyWith(
          environments: environments,
          selectedEnvironment:
              environments.isNotEmpty ? environments.first : null,
          status: EnvironmentStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> createEnvironment(String name, Color color) async {
    final currentProject = _projectCubit.state.currentProject;
    if (currentProject == null) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: 'No hay un proyecto seleccionado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      final environment = Environment(
        projectId: currentProject.id,
        name: name,
        color: color,
        variables: {},
      );

      final createdEnvironment = await _environmentRepository.createEnvironment(
        environment,
      );

      final environments = List<Environment>.from(state.environments)
        ..add(createdEnvironment);

      emit(
        state.copyWith(
          environments: environments,
          selectedEnvironment: state.selectedEnvironment ?? createdEnvironment,
          status: EnvironmentStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateEnvironment(
    Environment environment, {
    String? name,
    Color? color,
    Map<String, String>? variables,
  }) async {
    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      final updatedEnvironment = environment.copyWith(
        name: name,
        color: color,
        variables: variables,
      );

      await _environmentRepository.updateEnvironment(updatedEnvironment);

      final environments =
          state.environments
              .map((e) => e.id == environment.id ? updatedEnvironment : e)
              .toList();

      // Actualizar el entorno seleccionado si es el mismo
      final updatedSelectedEnvironment =
          state.selectedEnvironment?.id == environment.id
              ? updatedEnvironment
              : state.selectedEnvironment;

      emit(
        state.copyWith(
          environments: environments,
          selectedEnvironment: updatedSelectedEnvironment,
          status: EnvironmentStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteEnvironment(String environmentId) async {
    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      await _environmentRepository.deleteEnvironment(environmentId);

      final environments =
          state.environments.where((e) => e.id != environmentId).toList();

      // Si se eliminó el entorno seleccionado, seleccionar otro
      Environment? updatedSelectedEnvironment = state.selectedEnvironment;
      if (state.selectedEnvironment?.id == environmentId) {
        updatedSelectedEnvironment =
            environments.isNotEmpty ? environments.first : null;
      }

      emit(
        state.copyWith(
          environments: environments,
          selectedEnvironment: updatedSelectedEnvironment,
          status: EnvironmentStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void selectEnvironment(Environment environment) {
    if (state.selectedEnvironment?.id != environment.id) {
      emit(state.copyWith(selectedEnvironment: environment));
    }
  }

  Future<void> addVariable(
    String environmentId,
    String name,
    String value,
  ) async {
    final environment = state.environments.firstWhere(
      (e) => e.id == environmentId,
      orElse: () => null as Environment,
    );

    if (environment == null) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: 'Entorno no encontrado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      final variables = Map<String, String>.from(environment.variables);
      variables[name] = value;

      await updateEnvironment(environment, variables: variables);
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateVariable(
    String environmentId,
    String oldName,
    String newName,
    String value,
  ) async {
    final environment = state.environments.firstWhere(
      (e) => e.id == environmentId,
      orElse: () => null as Environment,
    );

    if (environment == null) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: 'Entorno no encontrado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      final variables = Map<String, String>.from(environment.variables);

      // Si el nombre cambió, eliminar la variable antigua
      if (oldName != newName) {
        variables.remove(oldName);
      }

      variables[newName] = value;

      await updateEnvironment(environment, variables: variables);
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteVariable(String environmentId, String name) async {
    final environment = state.environments.firstWhere(
      (e) => e.id == environmentId,
      orElse: () => null as Environment,
    );

    if (environment == null) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: 'Entorno no encontrado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EnvironmentStatus.loading));

    try {
      final variables = Map<String, String>.from(environment.variables);
      variables.remove(name);

      await updateEnvironment(environment, variables: variables);
    } catch (e) {
      emit(
        state.copyWith(
          status: EnvironmentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
