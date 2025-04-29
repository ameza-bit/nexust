import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class BodyEditor extends StatefulWidget {
  final String initialBody;
  final Function(String) onBodyChanged;

  const BodyEditor({
    super.key,
    required this.initialBody,
    required this.onBodyChanged,
  });

  @override
  State<BodyEditor> createState() => _BodyEditorState();
}

class _BodyEditorState extends State<BodyEditor> {
  late TextEditingController _bodyController;
  late int _selectedBodyTypeIndex;
  bool _isFormatted = true;

  final List<String> _bodyTypes = ['JSON', 'Form', 'Text', 'XML', 'Binary'];

  final Map<String, String> _bodyTemplates = {
    'JSON':
        '{\n  "key": "value",\n  "number": 123,\n  "array": [\n    "item1",\n    "item2"\n  ]\n}',
    'Form': 'key=value&another=123&check=true',
    'Text': 'Plain text body content',
    'XML':
        '<?xml version="1.0" encoding="UTF-8"?>\n<root>\n  <item id="1">Value</item>\n  <item id="2">Another value</item>\n</root>',
    'Binary': '(Binary content cannot be previewed)',
  };

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController(text: widget.initialBody);
    _selectedBodyTypeIndex = 0; // JSON por defecto
    _bodyController.addListener(_onBodyChanged);
  }

  @override
  void dispose() {
    _bodyController.removeListener(_onBodyChanged);
    _bodyController.dispose();
    super.dispose();
  }

  void _onBodyChanged() {
    widget.onBodyChanged(_bodyController.text);
  }

  void _selectBodyType(int index) {
    setState(() {
      _selectedBodyTypeIndex = index;

      // Si el cuerpo está vacío o es una plantilla, cambiarlo
      if (_bodyController.text.isEmpty || _isTemplate()) {
        _bodyController.text = _bodyTemplates[_bodyTypes[index]] ?? '';
        _onBodyChanged();
      }
    });
  }

  bool _isTemplate() {
    for (var template in _bodyTemplates.values) {
      if (_bodyController.text == template) {
        return true;
      }
    }
    return false;
  }

  void _formatBody() {
    try {
      if (_bodyTypes[_selectedBodyTypeIndex] == 'JSON') {
        // Simulación de formateo de JSON (en una app real, usaríamos dart:convert)
        final prettyJson = _bodyController.text;
        _bodyController.text = prettyJson;
        setState(() {
          _isFormatted = true;
        });
      }
    } catch (e) {
      // No hacer nada si hay un error de formateo
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y descripción
            Text(
              "Cuerpo de la petición",
              style: TextStyle(
                fontSize: context.scaleText(16),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Define el contenido del cuerpo que se enviará con la petición",
              style: TextStyle(
                fontSize: context.scaleText(14),
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // Selector de tipo de cuerpo
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_bodyTypes.length, (index) {
                  final isSelected = index == _selectedBodyTypeIndex;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        _bodyTypes[index],
                        style: TextStyle(
                          fontSize: context.scaleText(12),
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: theme.primaryColor,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      onSelected: (selected) {
                        if (selected) _selectBodyType(index);
                      },
                    ),
                  );
                }),
              ),
            ),

            // Barra de herramientas para el editor
            if (_bodyTypes[_selectedBodyTypeIndex] == 'JSON')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.lightCodeBranch,
                        size: context.scaleIcon(16),
                        color:
                            isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                      ),
                      onPressed: _formatBody,
                      tooltip: "Formatear JSON",
                      splashRadius: 20,
                    ),
                    Text(
                      "Formatear",
                      style: TextStyle(
                        fontSize: context.scaleText(12),
                        color:
                            isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

            // Editor de cuerpo
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black12 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: _bodyController,
                style: TextStyle(
                  fontSize: context.scaleText(14),
                  fontFamily: 'monospace',
                ),
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Ingresa el cuerpo de la petición...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    fontSize: context.scaleText(14),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
