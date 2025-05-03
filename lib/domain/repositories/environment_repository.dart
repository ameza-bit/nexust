import 'package:nexust/data/models/environment.dart';

abstract class EnvironmentRepository {
  Future<List<Environment>> getEnvironments(String projectId);
  Future<Environment?> getEnvironmentById(String id);
  Future<Environment> createEnvironment(Environment environment);
  Future<void> updateEnvironment(Environment environment);
  Future<void> deleteEnvironment(String id);
}
