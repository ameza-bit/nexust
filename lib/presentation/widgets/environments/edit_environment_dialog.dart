import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/data/models/environment.dart';

class EditEnvironmentDialog extends StatefulWidget {
  final Environment environment;
  final Function(String, Color) onSave;

  const EditEnvironmentDialog({
    super.key,
    required this.environment,
    required this.onSave,
  });

  @override
  State<EditEnvironmentDialog> createState() => _EditEnvironmentDialogState();
}

class _EditEnvironmentDialogState extends State<EditEnvironmentDialog> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  late Color _selectedColor;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.environment.name);
    _selectedColor = widget.environment.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(context.tr('environments.edit_environment')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.tr('environments.environment_name'),
                hintText: context.tr('environments.environment_name_hint'),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
              autofocus: true,
            ),
            SizedBox(height: 16),

            Text(
              context.tr('environments.environment_color'),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Selector de color
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  _availableColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                _selectedColor == color
                                    ? Colors.white
                                    : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            if (_selectedColor == color)
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                        child:
                            _selectedColor == color
                                ? Icon(Icons.check, color: Colors.white)
                                : null,
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('common.cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              widget.onSave(_nameController.text.trim(), _selectedColor);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(context.tr('common.save')),
        ),
      ],
    );
  }
}
