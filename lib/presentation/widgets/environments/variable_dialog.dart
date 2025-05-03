import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VariableDialog extends StatefulWidget {
  final String? initialName;
  final String? initialValue;
  final Function(String, String) onSave;

  const VariableDialog({
    super.key,
    this.initialName,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<VariableDialog> createState() => _VariableDialogState();
}

class _VariableDialogState extends State<VariableDialog> {
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _valueController = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.initialName != null;

    return AlertDialog(
      title: Text(
        isEdit
            ? context.tr('environments.edit_variable')
            : context.tr('environments.add_variable'),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.tr('environments.variable_name'),
                hintText: context.tr('environments.variable_name_hint'),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                // Validar que el nombre sea un identificador válido
                if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(value)) {
                  return 'Solo se permiten letras, números y guiones bajos';
                }
                return null;
              },
              autofocus: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: context.tr('environments.variable_value'),
                hintText: context.tr('environments.variable_value_hint'),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El valor es obligatorio';
                }
                return null;
              },
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
              widget.onSave(
                _nameController.text.trim(),
                _valueController.text.trim(),
              );
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
