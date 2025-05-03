import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/environment.dart';
import 'package:nexust/domain/repositories/environment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvironmentRepositoryImpl implements EnvironmentRepository {
  static const String _environmentsKey = 'environments';

  @override
  Future<List<Environment>> getEnvironments(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final environmentsJson = prefs.getString(_environmentsKey);

    if (environmentsJson == null) {
      return [];
    }

    try {
      final List<Object?> decoded = List<Object?>.from(
        jsonDecode(environmentsJson) as List,
      );

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => Environment.fromJson(item))
          .where((env) => env.projectId == projectId)
          .toList();
    } catch (e) {
      Toast.show('Error al cargar entornos: $e');
      return [];
    }
  }

  @override
  Future<Environment?> getEnvironmentById(String id) async {
    final allEnvironments = await _getAllEnvironments();
    return allEnvironments.firstWhere(
      (env) => env.id == id,
      orElse: () => null as Environment,
    );
  }

  @override
  Future<Environment> createEnvironment(Environment environment) async {
    final environments = await _getAllEnvironments();

    // Evitar duplicados por ID
    if (environments.any((env) => env.id == environment.id)) {
      return environment;
    }

    environments.add(environment);
    await _saveAllEnvironments(environments);
    return environment;
  }

  @override
  Future<void> updateEnvironment(Environment environment) async {
    final environments = await _getAllEnvironments();
    final index = environments.indexWhere((env) => env.id == environment.id);

    if (index != -1) {
      environments[index] = environment;
      await _saveAllEnvironments(environments);
    }
  }

  @override
  Future<void> deleteEnvironment(String id) async {
    final environments = await _getAllEnvironments();
    environments.removeWhere((env) => env.id == id);
    await _saveAllEnvironments(environments);
  }

  // Método auxiliar para obtener todos los entornos
  Future<List<Environment>> _getAllEnvironments() async {
    final prefs = await SharedPreferences.getInstance();
    final environmentsJson = prefs.getString(_environmentsKey);

    if (environmentsJson == null) {
      return [];
    }

    try {
      final List<Object?> decoded = List<Object?>.from(
        jsonDecode(environmentsJson) as List,
      );

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => Environment.fromJson(item))
          .toList();
    } catch (e) {
      Toast.show('Error al cargar entornos: $e');
      return [];
    }
  }

  // Método auxiliar para guardar todos los entornos
  Future<void> _saveAllEnvironments(List<Environment> environments) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      environments.map((env) => env.toJson()).toList(),
    );
    await prefs.setString(_environmentsKey, encoded);
  }
}
