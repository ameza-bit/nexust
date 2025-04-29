import 'package:flutter/material.dart';
import 'package:nexust/core/utils/toast.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login Screen"),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                // TODO: Implement navigation logic
                Toast.show("Add logic for 'Navigating to the next screen'");
              },
              child: const Text("Go to Next Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
