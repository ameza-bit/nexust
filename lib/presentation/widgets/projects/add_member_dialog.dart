import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/data/enums/project_role.dart';

class AddMemberDialog extends StatefulWidget {
  final Function(String, ProjectRole) onSave;

  const AddMemberDialog({super.key, required this.onSave});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProjectRole _selectedRole = ProjectRole.viewer;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(context.tr('projects.members_management.invite_member')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: context.tr(
                  'projects.members_management.member_email',
                ),
                hintText: context.tr(
                  'projects.members_management.member_email_hint',
                ),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El email es obligatorio';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Email inválido';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
            ),
            SizedBox(height: 16),

            Text(
              context.tr('projects.members_management.role'),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Selector de rol
            DropdownButtonFormField<ProjectRole>(
              value: _selectedRole,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: ProjectRole.admin,
                  child: Text(
                    context.tr('projects.members_management.roles.admin'),
                  ),
                ),
                DropdownMenuItem(
                  value: ProjectRole.editor,
                  child: Text(
                    context.tr('projects.members_management.roles.editor'),
                  ),
                ),
                DropdownMenuItem(
                  value: ProjectRole.viewer,
                  child: Text(
                    context.tr('projects.members_management.roles.viewer'),
                  ),
                ),
              ],
              onChanged: (role) {
                setState(() {
                  if (role != null) {
                    _selectedRole = role;
                  }
                });
              },
            ),

            // Información del rol seleccionado
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                _getRoleDescription(context, _selectedRole),
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color:
                      theme.brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                ),
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
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              widget.onSave(_emailController.text.trim(), _selectedRole);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            context.tr('projects.members_management.send_invitation'),
          ),
        ),
      ],
    );
  }

  String _getRoleDescription(BuildContext context, ProjectRole role) {
    switch (role) {
      case ProjectRole.owner:
        return context.tr('projects.members_management.permissions.owner_desc');
      case ProjectRole.admin:
        return context.tr('projects.members_management.permissions.admin_desc');
      case ProjectRole.editor:
        return context.tr(
          'projects.members_management.permissions.editor_desc',
        );
      case ProjectRole.viewer:
        return context.tr(
          'projects.members_management.permissions.viewer_desc',
        );
    }
  }
}
