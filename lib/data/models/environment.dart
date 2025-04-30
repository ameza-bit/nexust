import 'package:flutter/material.dart';

class Environment {
  final String name;
  final Color color;
  final Map<String, String> variables;

  Environment({
    required this.name,
    required this.color,
    required this.variables,
  });
}
