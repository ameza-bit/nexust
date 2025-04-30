import 'dart:convert';
import 'package:nexust/data/enums/method.dart';
import 'package:uuid/uuid.dart';

class RestEndpoint {
  final String id;
  final String name;
  final bool isGroup;
  final Method method;
  final String path;
  final Map<String, dynamic>? parameters;
  final Map<String, String>? headers;
  final Object? body;
  final Map<String, dynamic>? response;
  final List<RestEndpoint> children;
  bool isExpanded;

  RestEndpoint({
    String? id,
    required this.name,
    required this.isGroup,
    this.method = Method.get,
    this.path = '',
    this.parameters,
    this.headers,
    this.body,
    this.response,
    this.children = const [],
    this.isExpanded = false,
  }) : id = id ?? const Uuid().v4();

  // Método para crear una copia con cambios opcionales
  RestEndpoint copyWith({
    String? id,
    String? name,
    bool? isGroup,
    Method? method,
    String? path,
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? response,
    List<RestEndpoint>? children,
    bool? isExpanded,
  }) {
    return RestEndpoint(
      id: id ?? this.id,
      name: name ?? this.name,
      isGroup: isGroup ?? this.isGroup,
      method: method ?? this.method,
      path: path ?? this.path,
      parameters: parameters ?? this.parameters,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      response: response ?? this.response,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  // Para duplicar un endpoint con un nuevo ID
  RestEndpoint duplicate() {
    return copyWith(
      id: const Uuid().v4(),
      name: '$name (copia)',
      children: children.map((child) => child.duplicate()).toList(),
    );
  }

  // Convertir a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isGroup': isGroup,
      'method': method.index,
      'path': path,
      'parameters': parameters,
      'headers': headers,
      'body':
          body is String
              ? body
              : body != null
              ? jsonEncode(body)
              : null,
      'response': response,
      'children': children.map((child) => child.toJson()).toList(),
      'isExpanded': isExpanded,
    };
  }

  // Crear desde JSON
  factory RestEndpoint.fromJson(Map<String, dynamic> json) {
    return RestEndpoint(
      id: json['id'],
      name: json['name'],
      isGroup: json['isGroup'],
      method: Method.values[json['method']],
      path: json['path'],
      parameters: json['parameters'],
      headers:
          json['headers'] != null
              ? Map<String, String>.from(json['headers'])
              : null,
      body: json['body'],
      response: json['response'],
      children:
          json['children'] != null
              ? (json['children'] as List)
                  .map((item) => RestEndpoint.fromJson(item))
                  .toList()
              : [],
      isExpanded: json['isExpanded'] ?? false,
    );
  }
}
