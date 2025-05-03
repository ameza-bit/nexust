import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Environment {
  final String id;
  final String projectId;
  final String name;
  final Color color;
  final Map<String, String> variables;

  Environment({
    String? id,
    required this.projectId,
    required this.name,
    required this.color,
    required this.variables,
  }) : id = id ?? const Uuid().v4();

  Environment copyWith({
    String? id,
    String? projectId,
    String? name,
    Color? color,
    Map<String, String>? variables,
  }) {
    return Environment(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      color: color ?? this.color,
      variables: variables ?? Map<String, String>.from(this.variables),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'color': color.toARGB32(),
      'variables': variables,
    };
  }

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      id: json['id'],
      projectId: json['projectId'],
      name: json['name'],
      color: Color(json['color']),
      variables: Map<String, String>.from(json['variables']),
    );
  }
}
