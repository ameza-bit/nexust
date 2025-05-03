import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/project_role.dart';
import 'package:nexust/data/enums/project_status.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/data/models/project_member.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';
import 'package:nexust/presentation/blocs/projects/project_state.dart';
import 'package:nexust/presentation/widgets/projects/add_member_dialog.dart';

class ProjectMembersScreen extends StatelessWidget {
  final Project project;

  const ProjectMembersScreen({super.key, required this.project});

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AddMemberDialog(
            onSave: (email, role) {
              context.read<ProjectCubit>().addMember(email, role);
              Toast.show(
                context.tr(
                  'projects.members_management.invitation_sent',
                  namedArgs: {'email': email},
                ),
              );
            },
          ),
    );
  }

  void _showRemoveMemberDialog(BuildContext context, ProjectMember member) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              context.tr('projects.members_management.remove_member'),
            ),
            content: Text(
              context.tr(
                'projects.members_management.remove_confirm',
                namedArgs: {'name': member.email},
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ProjectCubit>().removeMember(member.id);
                  Toast.show('Miembro eliminado correctamente');
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(context.tr('common.delete')),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('projects.members_management.title')),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.lightUserPlus),
            onPressed: () => _showAddMemberDialog(context),
            tooltip: context.tr('projects.members_management.add_member'),
          ),
        ],
      ),
      body: BlocBuilder<ProjectCubit, ProjectState>(
        builder: (context, state) {
          if (state.status == ProjectStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          final members = state.currentProjectMembers;

          if (members.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.lightUsers,
                    size: 64,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay miembros en este proyecto',
                    style: TextStyle(
                      fontSize: context.scaleText(18),
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddMemberDialog(context),
                    icon: Icon(FontAwesomeIcons.lightUserPlus),
                    label: Text(
                      context.tr('projects.members_management.add_member'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final member = members[index];
              final isOwner = member.role == ProjectRole.owner;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.primaryColor.withAlpha(
                    isDark ? 50 : 30,
                  ),
                  child: Icon(
                    FontAwesomeIcons.lightUser,
                    color: theme.primaryColor,
                    size: context.scaleIcon(16),
                  ),
                ),
                title: Text(
                  member.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.scaleText(16),
                  ),
                ),
                subtitle: Text(
                  context.tr(
                    'projects.members_management.roles.${member.role.name}',
                  ),
                  style: TextStyle(
                    fontSize: context.scaleText(14),
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                trailing:
                    isOwner
                        ? Chip(
                          label: Text(
                            context.tr(
                              'projects.members_management.roles.owner',
                            ),
                            style: TextStyle(
                              fontSize: context.scaleText(12),
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: theme.primaryColor.withAlpha(
                            isDark ? 40 : 30,
                          ),
                        )
                        : IconButton(
                          icon: Icon(
                            FontAwesomeIcons.lightTrash,
                            color: Colors.red,
                            size: context.scaleIcon(18),
                          ),
                          onPressed:
                              () => _showRemoveMemberDialog(context, member),
                          tooltip: context.tr(
                            'projects.members_management.remove_member',
                          ),
                        ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMemberDialog(context),
        tooltip: context.tr('projects.members_management.add_member'),
        child: Icon(FontAwesomeIcons.lightUserPlus),
      ),
    );
  }
}
