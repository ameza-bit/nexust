import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/environment.dart';
import 'package:nexust/presentation/blocs/environments/environment_cubit.dart';
import 'package:nexust/presentation/blocs/environments/environment_state.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';
import 'package:nexust/presentation/widgets/environments/create_environment_dialog.dart';
import 'package:nexust/presentation/widgets/environments/environment_detail_screen.dart';

class EnviromentsScreen extends StatefulWidget {
  static const String routeName = "enviroments_list";
  const EnviromentsScreen({super.key});

  @override
  State<EnviromentsScreen> createState() => _EnviromentsScreenState();
}

class _EnviromentsScreenState extends State<EnviromentsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar entornos del proyecto actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectCubit = context.read<ProjectCubit>();
      final environmentCubit = context.read<EnvironmentCubit>();

      if (projectCubit.state.currentProject != null) {
        environmentCubit.loadEnvironments();
      }
    });
  }

  void _showCreateEnvironmentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateEnvironmentDialog(
            onSave: (name, color) {
              context.read<EnvironmentCubit>().createEnvironment(name, color);
              Toast.show(context.tr('environments.environment_saved'));
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('environments.title'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.lightPlus),
            onPressed: _showCreateEnvironmentDialog,
            tooltip: context.tr('environments.new_environment'),
          ),
        ],
      ),
      body: BlocBuilder<EnvironmentCubit, EnvironmentState>(
        builder: (context, state) {
          if (state.status == EnvironmentStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.status == EnvironmentStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error desconocido',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.environments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.lightEarthAmericas,
                    size: 64,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.tr('environments.no_environments'),
                    style: TextStyle(
                      fontSize: context.scaleText(18),
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showCreateEnvironmentDialog,
                    icon: Icon(FontAwesomeIcons.lightPlus),
                    label: Text(
                      context.tr('environments.create_first_environment'),
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

          // Mostrar lista de entornos
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: state.environments.length,
            itemBuilder: (context, index) {
              final environment = state.environments[index];
              final isSelected =
                  state.selectedEnvironment?.id == environment.id;

              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side:
                      isSelected
                          ? BorderSide(color: environment.color, width: 2)
                          : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () {
                    // Navegar a la pantalla de detalle
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EnvironmentDetailScreen(
                              environment: environment,
                            ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: environment.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                environment.name,
                                style: TextStyle(
                                  fontSize: context.scaleText(18),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${environment.variables.length} ${context.tr('environments.variables').toLowerCase()}',
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
                        ),
                        Radio<String>(
                          value: environment.id,
                          groupValue: state.selectedEnvironment?.id,
                          onChanged: (_) {
                            context.read<EnvironmentCubit>().selectEnvironment(
                              environment,
                            );
                          },
                          activeColor: environment.color,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateEnvironmentDialog,
        tooltip: context.tr('environments.new_environment'),
        child: Icon(FontAwesomeIcons.lightPlus),
      ),
    );
  }
}
