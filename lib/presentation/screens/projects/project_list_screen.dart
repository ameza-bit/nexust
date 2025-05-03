import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/project_status.dart';
import 'package:nexust/data/models/project.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';
import 'package:nexust/presentation/blocs/projects/project_state.dart';
import 'package:nexust/presentation/screens/projects/project_detail_screen.dart';
import 'package:nexust/presentation/widgets/projects/create_project_dialog.dart';
import 'package:nexust/presentation/widgets/projects/project_card.dart';

class ProjectListScreen extends StatefulWidget {
  static const String routeName = 'project_list';

  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  String _searchQuery = '';
  int _filterIndex = 0; // 0: Todos, 1: Mis proyectos, 2: Compartidos conmigo

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    final projectCubit = context.read<ProjectCubit>();
    if (!projectCubit.state.isInitialized) {
      projectCubit.initialize();
    } else {
      projectCubit.loadProjects();
    }
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateProjectDialog(
            onSave: (name, description) {
              context.read<ProjectCubit>().createProject(name, description);
              Toast.show(context.tr('projects.project_saved'));
            },
          ),
    );
  }

  List<Project> _getFilteredProjects(ProjectState state) {
    if (state.projects.isEmpty) {
      return [];
    }

    // Aplicar filtros
    List<Project> filteredProjects = state.projects;

    if (_filterIndex == 1) {
      // Mis proyectos
      filteredProjects =
          filteredProjects
              .where(
                (p) =>
                    p.ownerId ==
                    context.read<ProjectCubit>().state.currentProject?.ownerId,
              )
              .toList();
    } else if (_filterIndex == 2) {
      // Compartidos conmigo
      filteredProjects =
          filteredProjects
              .where(
                (p) =>
                    p.ownerId !=
                    context.read<ProjectCubit>().state.currentProject?.ownerId,
              )
              .toList();
    }

    // Aplicar búsqueda
    if (_searchQuery.isNotEmpty) {
      filteredProjects =
          filteredProjects
              .where(
                (p) =>
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    p.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filteredProjects;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('projects.title'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.lightPlus),
            onPressed: _showCreateProjectDialog,
            tooltip: context.tr('projects.new_project'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Búsqueda y filtros
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Barra de búsqueda
                TextField(
                  decoration: InputDecoration(
                    hintText: context.tr('projects.filters.search'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),

                // Chips de filtro
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text(context.tr('projects.filters.all')),
                        selected: _filterIndex == 0,
                        onSelected: (selected) {
                          setState(() {
                            _filterIndex = 0;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text(context.tr('projects.filters.owned')),
                        selected: _filterIndex == 1,
                        onSelected: (selected) {
                          setState(() {
                            _filterIndex = 1;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text(context.tr('projects.filters.shared')),
                        selected: _filterIndex == 2,
                        onSelected: (selected) {
                          setState(() {
                            _filterIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de proyectos
          Expanded(
            child: BlocBuilder<ProjectCubit, ProjectState>(
              builder: (context, state) {
                if (state.status == ProjectStatus.loading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state.status == ProjectStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Error desconocido',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final filteredProjects = _getFilteredProjects(state);

                if (filteredProjects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.lightFolderOpen,
                          size: 64,
                          color:
                              isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty || _filterIndex != 0
                              ? context.tr('projects.no_results')
                              : context.tr('projects.no_projects'),
                          style: TextStyle(
                            fontSize: context.scaleText(18),
                            color:
                                isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                          ),
                        ),
                        if (_searchQuery.isEmpty && _filterIndex == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: ElevatedButton.icon(
                              onPressed: _showCreateProjectDialog,
                              icon: Icon(FontAwesomeIcons.lightPlus),
                              label: Text(
                                context.tr('projects.create_first_project'),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = filteredProjects[index];
                    final isCurrentProject =
                        state.currentProject?.id == project.id;

                    return ProjectCard(
                      project: project,
                      isCurrentProject: isCurrentProject,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ProjectDetailScreen(project: project),
                          ),
                        );
                      },
                      onSwitchProject: () {
                        context.read<ProjectCubit>().switchProject(project.id);
                        Toast.show(
                          context.tr(
                            'projects.current_project',
                            namedArgs: {'name': project.name},
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateProjectDialog,
        tooltip: context.tr('projects.new_project'),
        child: Icon(FontAwesomeIcons.lightPlus),
      ),
    );
  }
}
