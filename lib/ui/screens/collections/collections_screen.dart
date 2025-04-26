import 'package:flutter/material.dart';

class CollectionsScreen extends StatelessWidget {
  static const String routeName = "collections";
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collections")),
      body: const Center(child: Text("Collections Screen")),
    );
  }
}
