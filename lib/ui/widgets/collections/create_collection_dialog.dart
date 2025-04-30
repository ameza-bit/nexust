import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateCollectionDialog extends StatefulWidget {
  final Function(String) onSave;
  final String? initialName;

  const CreateCollectionDialog({
    super.key,
    required this.onSave,
    this.initialName,
  });

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        widget.initialName != null
            ? context.tr('collections.edit_collection')
            : context.tr('collections.new_collection'),
      ),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.tr('collections.collection_name'),
          hintText: context.tr('collections.collection_name_hint'),
          border: OutlineInputBorder(),
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
                    widget.onSave(_nameController.text.trim());
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
