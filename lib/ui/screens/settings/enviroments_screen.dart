import 'package:flutter/material.dart';

class EnviromentsScreen extends StatelessWidget {
  static const String routeName = "enviroments_list";
  const EnviromentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enviroments")),
      body: const Center(child: Text("Enviroments Screen")),
    );
  }
}
