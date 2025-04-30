import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/data/enums/method.dart';

class CreateEndpointDialog extends StatefulWidget {
  final Function(String, Method, String) onSave;
  final String? initialName;
  final Method? initialMethod;
  final String? initialPath;

  const CreateEndpointDialog({
    super.key,
    required this.onSave,
    this.initialName,
    this.initialMethod,
    this.initialPath,
  });

  @override
  State<CreateEndpointDialog> createState() => _CreateEndpointDialogState();
}

class _CreateEndpointDialogState extends State<CreateEndpointDialog> {
  late TextEditingController _nameController;
  late TextEditingController _pathController;
  late Method _selectedMethod;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _pathController = TextEditingController(text: widget.initialPath ?? '');
    _selectedMethod = widget.initialMethod ?? Method.get;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _pathController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        widget.initialName != null
            ? context.tr('collections.edit_endpoint')
            : context.tr('collections.new_endpoint'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del endpoint
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: context.tr('collections.endpoint_name'),
                hintText: context.tr('collections.endpoint_name_hint'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Selector de método
            Text(context.tr('collections.http_method')),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.black12 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Method>(
                  isExpanded: true,
                  value: _selectedMethod,
                  onChanged: (Method? value) {
                    if (value != null) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    }
                  },
                  items:
                      Method.values.map((Method method) {
                        return DropdownMenuItem<Method>(
                          value: method,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: method.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  method.stringName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),

            // URL del endpoint
            TextField(
              controller: _pathController,
              decoration: InputDecoration(
                labelText: context.tr('collections.endpoint_url'),
                hintText: 'https://api.example.com/endpoint',
                border: OutlineInputBorder(),
              ),
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
          onPressed:
              _isValid
                  ? () {
                    Navigator.pop(context);
                    widget.onSave(
                      _nameController.text.trim(),
                      _selectedMethod,
                      _pathController.text.trim(),
                    );
                  }
                  : null,
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
