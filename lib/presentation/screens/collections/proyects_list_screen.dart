import 'package:flutter/material.dart';

class ProyectsListScreen extends StatelessWidget {
  static const String routeName = 'proyects_list';
  const ProyectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proyects List')),
      body: const Center(child: Text('Proyects List Screen')),
    );
  }
}
