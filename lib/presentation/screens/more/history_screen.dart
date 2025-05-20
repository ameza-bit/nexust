import 'package:flutter/material.dart';
import 'package:nexust/presentation/widgets/common/web_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  static const String routeName = "history";
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      appBar: AppBar(title: const Text('History Screen')),
      body: const Center(child: Text('History Screen')),
    );
  }
}
