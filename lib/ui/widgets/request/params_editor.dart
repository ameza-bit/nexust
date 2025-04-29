import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class ParamsEditor extends StatefulWidget {
  final Map<String, String> initialParams;
  final Function(Map<String, String>) onParamsChanged;

  const ParamsEditor({
    super.key,
    required this.initialParams,
    required this.onParamsChanged,
  });

  @override
  State<ParamsEditor> createState() => _ParamsEditorState();
}

class _ParamsEditorState extends State<ParamsEditor> {
  late List<_ParamItem> _params;

  @override
  void initState() {
    super.initState();
    _initParams();
  }

  void _initParams() {
    _params = [];

    // Si no hay parámetros iniciales, agregar uno vacío
    if (widget.initialParams.isEmpty) {
      _params.add(_ParamItem(key: '', value: '', enabled: true));
    } else {
      // Convertir los parámetros iniciales a items
      widget.initialParams.forEach((key, value) {
        _params.add(_ParamItem(key: key, value: value, enabled: true));
      });
    }
  }

  void _addParam() {
    setState(() {
      _params.add(_ParamItem(key: '', value: '', enabled: true));
    });
  }

  void _removeParam(int index) {
    setState(() {
      _params.removeAt(index);
      _updateParams();
    });
  }

  void _updateParam(int index, {String? key, String? value, bool? enabled}) {
    setState(() {
      if (key != null) _params[index].key = key;
      if (value != null) _params[index].value = value;
      if (enabled != null) _params[index].enabled = enabled;
      _updateParams();
    });
  }

  void _updateParams() {
    final Map<String, String> updatedParams = {};

    for (var param in _params) {
      if (param.enabled && param.key.isNotEmpty) {
        updatedParams[param.key] = param.value;
      }
    }

    widget.onParamsChanged(updatedParams);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y descripción
          Text(
            "Parámetros de consulta",
            style: TextStyle(
              fontSize: context.scaleText(16),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Agrega parámetros para incluir en la URL de la petición",
            style: TextStyle(
              fontSize: context.scaleText(14),
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Encabezados de la tabla
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const SizedBox(width: 24), // Espacio para el checkbox
                Expanded(
                  flex: 2,
                  child: Text(
                    "CLAVE",
                    style: TextStyle(
                      fontSize: context.scaleText(12),
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    "VALOR",
                    style: TextStyle(
                      fontSize: context.scaleText(12),
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Espacio para el botón de eliminar
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Lista de parámetros
          Expanded(
            child: ListView.builder(
              itemCount: _params.length,
              itemBuilder: (context, index) {
                final param = _params[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      // Checkbox para habilitar/deshabilitar
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: param.enabled,
                          onChanged: (value) {
                            _updateParam(index, enabled: value);
                          },
                          activeColor: theme.primaryColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                      // Campo para la clave
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color:
                                isDark ? Colors.black12 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color:
                                  isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: TextEditingController(text: param.key),
                            onChanged: (value) {
                              _updateParam(index, key: value);
                            },
                            style: TextStyle(
                              fontSize: context.scaleText(14),
                              color:
                                  param.enabled
                                      ? (isDark ? Colors.white : Colors.black87)
                                      : (isDark
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade400),
                            ),
                            decoration: InputDecoration(
                              hintText: 'clave',
                              hintStyle: TextStyle(
                                color:
                                    isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                fontSize: context.scaleText(14),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                            ),
                            enabled: param.enabled,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Campo para el valor
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isDark ? Colors.black12 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color:
                                  isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: TextEditingController(
                              text: param.value,
                            ),
                            onChanged: (value) {
                              _updateParam(index, value: value);
                            },
                            style: TextStyle(
                              fontSize: context.scaleText(14),
                              color:
                                  param.enabled
                                      ? (isDark ? Colors.white : Colors.black87)
                                      : (isDark
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade400),
                            ),
                            decoration: InputDecoration(
                              hintText: 'valor',
                              hintStyle: TextStyle(
                                color:
                                    isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                fontSize: context.scaleText(14),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                            ),
                            enabled: param.enabled,
                          ),
                        ),
                      ),

                      // Botón para eliminar
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.lightTrash,
                          size: context.scaleIcon(16),
                          color:
                              isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                        onPressed: () => _removeParam(index),
                        splashRadius: 20,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Botón para agregar parámetro
          TextButton.icon(
            onPressed: _addParam,
            icon: Icon(
              FontAwesomeIcons.lightPlus,
              size: context.scaleIcon(16),
              color: theme.primaryColor,
            ),
            label: Text(
              "Agregar parámetro",
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: context.scaleText(14),
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParamItem {
  String key;
  String value;
  bool enabled;

  _ParamItem({required this.key, required this.value, required this.enabled});
}
