import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/models/environment.dart';

class EnvironmentSelector extends StatefulWidget {
  final List<Environment> environments;
  final Environment? selectedEnvironment;
  final Function(Environment?) onEnvironmentSelected;

  const EnvironmentSelector({
    super.key,
    required this.environments,
    this.selectedEnvironment,
    required this.onEnvironmentSelected,
  });

  @override
  State<EnvironmentSelector> createState() => _EnvironmentSelectorState();
}

class _EnvironmentSelectorState extends State<EnvironmentSelector> {
  late Environment? _selectedEnvironment;

  @override
  void initState() {
    super.initState();
    _selectedEnvironment = widget.selectedEnvironment;
  }

  @override
  void didUpdateWidget(EnvironmentSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedEnvironment != oldWidget.selectedEnvironment) {
      _selectedEnvironment = widget.selectedEnvironment;
    }
  }

  void _selectEnvironment(Environment? env) {
    setState(() {
      _selectedEnvironment = env;
    });
    widget.onEnvironmentSelected(env);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        _showEnvironmentSelector(context);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.black12 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedEnvironment != null) ...[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _selectedEnvironment!.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                _selectedEnvironment!.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: context.scaleText(14),
                ),
              ),
            ] else
              Text(
                "Sin entorno",
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: context.scaleText(14),
                ),
              ),
            SizedBox(width: 4),
            Icon(
              FontAwesomeIcons.lightChevronDown,
              size: context.scaleIcon(12),
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  void _showEnvironmentSelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? theme.cardColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Seleccionar entorno",
                      style: TextStyle(
                        fontSize: context.scaleText(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.lightGear),
                      onPressed: () {
                        Navigator.pop(context);
                        _showEnvironmentManager(context);
                      },
                      tooltip: "Gestionar entornos",
                      iconSize: context.scaleIcon(18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Divider(),
              // Default "No environment" option
              ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                    ),
                  ),
                  child:
                      _selectedEnvironment == null
                          ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: context.scaleIcon(14),
                          )
                          : null,
                ),
                title: Text("Sin entorno"),
                onTap: () {
                  _selectEnvironment(null);
                  Navigator.pop(context);
                },
              ),
              ...widget.environments.map((env) {
                final isSelected = _selectedEnvironment?.name == env.name;
                return ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: env.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                      ),
                    ),
                    child:
                        isSelected
                            ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: context.scaleIcon(14),
                            )
                            : null,
                  ),
                  title: Text(env.name),
                  subtitle: Text(
                    "${env.variables.length} variables",
                    style: TextStyle(fontSize: context.scaleText(12)),
                  ),
                  onTap: () {
                    _selectEnvironment(env);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showEnvironmentManager(BuildContext context) {
    // Aquí iría un diálogo o pantalla más compleja para gestionar entornos
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Gestionar entornos"),
          content: Text(
            "Aquí se implementaría la gestión de entornos y variables",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
