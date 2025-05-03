import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';
import 'package:nexust/presentation/blocs/projects/project_state.dart';
import 'package:nexust/presentation/screens/projects/project_members_screen.dart';
import 'package:nexust/presentation/screens/settings/enviroments_screen.dart';
import 'package:nexust/presentation/widgets/projects/edit_project_dialog.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Project _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  void _showEditProjectDialog() {
    showDialog(
      context: context,
      builder:
          (context) => EditProjectDialog(
            project: _project,
            onSave: (name, description) {
              final updatedProject = _project.copyWith(
                name: name,
                description: description,
              );

              context.read<ProjectCubit>().updateProject(updatedProject);

              setState(() {
                _project = updatedProject;
              });

              Toast.show(context.tr('projects.project_saved'));
            },
          ),
    );
  }

  void _showDeleteProjectDialog() {
    if (_project.isPersonal) {
      Toast.show(context.tr('projects.cannot_delete_personal'));
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('projects.delete_project')),
            content: Text(
              context.tr(
                'projects.delete_confirm',
                namedArgs: {'name': _project.name},
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
                  context.read<ProjectCubit>().deleteProject(_project.id);
                  Navigator.pop(context); // Volver a la lista de proyectos
                  Toast.show(context.tr('projects.project_deleted'));
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
        title: Text(_project.name),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.lightPenToSquare),
            onPressed: _showEditProjectDialog,
            tooltip: context.tr('projects.edit_project'),
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.lightTrash,
              color: _project.isPersonal ? Colors.grey : Colors.red,
            ),
            onPressed: _project.isPersonal ? null : _showDeleteProjectDialog,
            tooltip: context.tr('projects.delete_project'),
          ),
        ],
      ),
      body: BlocBuilder<ProjectCubit, ProjectState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta de información del proyecto
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y Tipo
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _project.name,
                                style: TextStyle(
                                  fontSize: context.scaleText(24),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (_project.isPersonal)
                              Chip(
                                label: Text(
                                  context.tr('projects.personal_project'),
                                ),
                                backgroundColor: theme.primaryColor.withAlpha(
                                  isDark ? 40 : 30,
                                ),
                                labelStyle: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: context.scaleText(12),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Descripción
                        Text(
                          _project.description,
                          style: TextStyle(
                            fontSize: context.scaleText(16),
                            color:
                                isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Fecha de creación
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.lightCalendarDays,
                              size: context.scaleIcon(16),
                              color:
                                  isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${context.tr('projects.created_at')}: ${DateFormat.yMMMd().format(_project.createdAt)}',
                              style: TextStyle(
                                fontSize: context.scaleText(14),
                                color:
                                    isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        // Botón de cambiar proyecto
                        if (state.currentProject?.id != _project.id)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<ProjectCubit>().switchProject(
                                  _project.id,
                                );
                                Toast.show(
                                  context.tr(
                                    'projects.current_project',
                                    namedArgs: {'name': _project.name},
                                  ),
                                );
                              },
                              icon: Icon(FontAwesomeIcons.lightRightToBracket),
                              label: Text(context.tr('projects.switch_to')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Secciones
                Text(
                  context.tr('projects.members'),
                  style: TextStyle(
                    fontSize: context.scaleText(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                // Tarjeta de miembros
                Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withAlpha(isDark ? 40 : 30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        FontAwesomeIcons.lightUsers,
                        color: theme.primaryColor,
                        size: context.scaleIcon(24),
                      ),
                    ),
                    title: Text(
                      context.tr('projects.members'),
                      style: TextStyle(
                        fontSize: context.scaleText(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${state.currentProjectMembers.length} ${context.tr('projects.members').toLowerCase()}',
                      style: TextStyle(fontSize: context.scaleText(14)),
                    ),
                    trailing: Icon(FontAwesomeIcons.lightChevronRight),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProjectMembersScreen(project: _project),
                        ),
                      );
                    },
                  ),
                ),

                // Sección de Entornos
                Text(
                  context.tr('projects.environments'),
                  style: TextStyle(
                    fontSize: context.scaleText(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                // Tarjeta de entornos
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withAlpha(isDark ? 40 : 30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        FontAwesomeIcons.lightEarthAmericas,
                        color: theme.primaryColor,
                        size: context.scaleIcon(24),
                      ),
                    ),
                    title: Text(
                      context.tr('projects.environments'),
                      style: TextStyle(
                        fontSize: context.scaleText(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      context.tr('environments.project_environments'),
                      style: TextStyle(fontSize: context.scaleText(14)),
                    ),
                    trailing: Icon(FontAwesomeIcons.lightChevronRight),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnviromentsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
