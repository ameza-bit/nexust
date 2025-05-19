import 'package:flutter/material.dart';

class CollectionListScreen extends StatelessWidget {
  static const String routeName = 'collection_list';
  const CollectionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collection List')),
      body: Center(child: Text('Collection List')),
    );
  }
}
