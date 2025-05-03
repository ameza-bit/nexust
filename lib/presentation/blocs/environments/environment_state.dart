import 'package:equatable/equatable.dart';
import 'package:nexust/data/enums/environment_status.dart';
import 'package:nexust/data/models/environment.dart';

class EnvironmentState extends Equatable {
  final List<Environment> environments;
  final Environment? selectedEnvironment;
  final EnvironmentStatus status;
  final String? errorMessage;

  const EnvironmentState({
    this.environments = const [],
    this.selectedEnvironment,
    this.status = EnvironmentStatus.initial,
    this.errorMessage,
  });

  EnvironmentState copyWith({
    List<Environment>? environments,
    Environment? selectedEnvironment,
    EnvironmentStatus? status,
    String? errorMessage,
  }) {
    return EnvironmentState(
      environments: environments ?? this.environments,
      selectedEnvironment: selectedEnvironment,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    environments,
    selectedEnvironment,
    status,
    errorMessage,
  ];
}
