import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectScreen extends StatefulWidget {
  static const String routeName = 'redirect';
  const RedirectScreen(this.redirectUrl, this.waitTime, {super.key});
  final String redirectUrl;
  final int waitTime;

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.waitTime > 0) {
        Future.delayed(Duration(milliseconds: widget.waitTime), () {
          if (mounted) {
            context.go(widget.redirectUrl);
          }
        });
      } else {
        context.go(widget.redirectUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.black);
}
