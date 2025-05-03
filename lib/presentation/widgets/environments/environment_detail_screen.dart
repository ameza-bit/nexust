import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/models/environment.dart';
import 'package:nexust/presentation/blocs/environments/environment_cubit.dart';
import 'package:nexust/presentation/blocs/environments/environment_state.dart';
import 'package:nexust/presentation/widgets/environments/edit_environment_dialog.dart';
import 'package:nexust/presentation/widgets/environments/variable_dialog.dart';

class EnvironmentDetailScreen extends StatefulWidget {
  final Environment environment;

  const EnvironmentDetailScreen({super.key, required this.environment});

  @override
  State<EnvironmentDetailScreen> createState() =>
      _EnvironmentDetailScreenState();
}

class _EnvironmentDetailScreenState extends State<EnvironmentDetailScreen> {
  late Environment _environment;

  @override
  void initState() {
    super.initState();
    _environment = widget.environment;
  }

  void _showEditEnvironmentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => EditEnvironmentDialog(
            environment: _environment,
            onSave: (name, color) {
              context.read<EnvironmentCubit>().updateEnvironment(
                _environment,
                name: name,
                color: color,
              );
              setState(() {
                _environment = _environment.copyWith(name: name, color: color);
              });
              Toast.show(context.tr('environments.environment_saved'));
            },
          ),
    );
  }

  void _showDeleteEnvironmentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('environments.delete_environment')),
            content: Text(
              'Are you sure you want to delete this environment and all its variables?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<EnvironmentCubit>().deleteEnvironment(
                    _environment.id,
                  );
                  Navigator.pop(context); // Volver a la lista
                  Toast.show(context.tr('environments.environment_deleted'));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(context.tr('common.delete')),
              ),
            ],
          ),
    );
  }

  void _showAddVariableDialog() {
    showDialog(
      context: context,
      builder:
          (context) => VariableDialog(
            onSave: (name, value) {
              context.read<EnvironmentCubit>().addVariable(
                _environment.id,
                name,
                value,
              );

              // Actualizar la UI con la nueva variable
              setState(() {
                final variables = Map<String, String>.from(
                  _environment.variables,
                );
                variables[name] = value;
                _environment = _environment.copyWith(variables: variables);
              });

              Toast.show(context.tr('environments.variable_saved'));
            },
          ),
    );
  }

  void _showEditVariableDialog(String name, String value) {
    showDialog(
      context: context,
      builder:
          (context) => VariableDialog(
            initialName: name,
            initialValue: value,
            onSave: (newName, newValue) {
              context.read<EnvironmentCubit>().updateVariable(
                _environment.id,
                name,
                newName,
                newValue,
              );

              // Actualizar la UI con la variable editada
              setState(() {
                final variables = Map<String, String>.from(
                  _environment.variables,
                );
                if (name != newName) {
                  variables.remove(name);
                }
                variables[newName] = newValue;
                _environment = _environment.copyWith(variables: variables);
              });

              Toast.show(context.tr('environments.variable_saved'));
            },
          ),
    );
  }

  void _deleteVariable(String name) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('environments.delete_variable')),
            content: Text('Are you sure you want to delete this variable?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<EnvironmentCubit>().deleteVariable(
                    _environment.id,
                    name,
                  );

                  // Actualizar la UI eliminando la variable
                  setState(() {
                    final variables = Map<String, String>.from(
                      _environment.variables,
                    );
                    variables.remove(name);
                    _environment = _environment.copyWith(variables: variables);
                  });

                  Toast.show(context.tr('environments.variable_deleted'));
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
        title: Text(_environment.name),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.lightPenToSquare),
            onPressed: _showEditEnvironmentDialog,
            tooltip: context.tr('environments.edit_environment'),
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.lightTrash, color: Colors.red),
            onPressed: _showDeleteEnvironmentDialog,
            tooltip: context.tr('environments.delete_environment'),
          ),
        ],
      ),
      body: BlocBuilder<EnvironmentCubit, EnvironmentState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de información del entorno
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _environment.color.withAlpha(isDark ? 40 : 20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _environment.color, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _environment.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          _environment.name,
                          style: TextStyle(
                            fontSize: context.scaleText(20),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Info de uso
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.black12
                                : Colors.white.withAlpha(150),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('environments.usage_info'),
                            style: TextStyle(
                              fontSize: context.scaleText(14),
                              fontStyle: FontStyle.italic,
                              color:
                                  isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "{{API_URL}}",
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: context.scaleText(14),
                              fontWeight: FontWeight.bold,
                              color: _environment.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Título de variables
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('environments.variables'),
                      style: TextStyle(
                        fontSize: context.scaleText(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.lightPlus),
                      onPressed: _showAddVariableDialog,
                      tooltip: context.tr('environments.add_variable'),
                      color: theme.primaryColor,
                    ),
                  ],
                ),
              ),

              // Lista de variables
              Expanded(
                child:
                    _environment.variables.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.lightCodeCompare,
                                size: 64,
                                color:
                                    isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                context.tr('environments.no_variables'),
                                style: TextStyle(
                                  fontSize: context.scaleText(18),
                                  color:
                                      isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _showAddVariableDialog,
                                icon: Icon(FontAwesomeIcons.lightPlus),
                                label: Text(
                                  context.tr('environments.add_first_variable'),
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
                        )
                        : ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemCount: _environment.variables.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            final entry = _environment.variables.entries
                                .elementAt(index);

                            return ListTile(
                              title: Text(
                                entry.key,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                  fontSize: context.scaleText(16),
                                ),
                              ),
                              subtitle: Text(
                                entry.value,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: context.scaleText(14),
                                  color:
                                      isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.lightPenToSquare,
                                      size: context.scaleIcon(16),
                                    ),
                                    onPressed:
                                        () => _showEditVariableDialog(
                                          entry.key,
                                          entry.value,
                                        ),
                                    tooltip: context.tr(
                                      'environments.edit_variable',
                                    ),
                                    splashRadius: 20,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.lightTrash,
                                      size: context.scaleIcon(16),
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteVariable(entry.key),
                                    tooltip: context.tr(
                                      'environments.delete_variable',
                                    ),
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVariableDialog,
        tooltip: context.tr('environments.add_variable'),
        child: Icon(FontAwesomeIcons.lightPlus),
      ),
    );
  }
}
