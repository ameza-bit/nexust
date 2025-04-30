import 'package:flutter/material.dart';

class RequestHistoryListScreen extends StatelessWidget {
  static const String routeName = "request_history_list";
  const RequestHistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request History List")),
      body: const Center(child: Text("Request History List Screen")),
    );
  }
}
