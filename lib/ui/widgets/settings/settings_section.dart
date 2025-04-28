import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children:
                children
                    .asMap()
                    .map((index, child) {
                      final isLast = index == children.length - 1;
                      return MapEntry(
                        index,
                        Column(
                          children: [
                            child,
                            if (!isLast)
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 70,
                                endIndent: 15,
                                color: Colors.grey.shade200,
                              ),
                          ],
                        ),
                      );
                    })
                    .values
                    .toList(),
          ),
        ),
      ],
    );
  }
}
