import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final DateTime createdAt;
  final bool isPersonal;

  Project({
    String? id,
    required this.name,
    this.description = '',
    required this.ownerId,
    DateTime? createdAt,
    this.isPersonal = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    DateTime? createdAt,
    bool? isPersonal,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      isPersonal: isPersonal ?? this.isPersonal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'isPersonal': isPersonal,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      ownerId: json['ownerId'],
      createdAt: DateTime.parse(json['createdAt']),
      isPersonal: json['isPersonal'] ?? false,
    );
  }
}
