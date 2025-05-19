import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  static const String routeName = 'request_list';
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request List')),
      body: Center(child: Text('Request List')),
    );
  }
}
