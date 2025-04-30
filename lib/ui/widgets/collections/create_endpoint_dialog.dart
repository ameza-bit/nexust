import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/models/rest_endpoint.dart';

class CreateEndpointDialog extends StatefulWidget {
  final Function(String, Method, String, String?) onSave;
  final String? initialName;
  final Method? initialMethod;
  final String? initialPath;
  final String? initialParentId;
  final List<RestEndpoint> collections;

  const CreateEndpointDialog({
    super.key,
    required this.onSave,
    this.initialName,
    this.initialMethod,
    this.initialPath,
    this.initialParentId,
    required this.collections,
  });

  @override
  State<CreateEndpointDialog> createState() => _CreateEndpointDialogState();
}

class _CreateEndpointDialogState extends State<CreateEndpointDialog> {
  late TextEditingController _nameController;
  String? _selectedParentId;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedParentId = widget.initialParentId;

    // Verificar validez inicial
    _updateValidity();

    // Agregar listener para actualizar validez cuando cambia el texto
    _nameController.addListener(_updateValidity);
  }

  void _updateValidity() {
    setState(() {
      _isValid = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateValidity);
    _nameController.dispose();
    super.dispose();
  }

  // Método para generar los ítems del dropdown
  List<DropdownMenuItem<String?>> _buildDropdownItems() {
    // Primero añadimos la opción de raíz
    final items = [DropdownMenuItem<String?>(value: null, child: Text("Raíz"))];

    // Función recursiva para añadir colecciones con indentación
    void addCollectionItems(List<RestEndpoint> collections, int depth) {
      for (var collection in collections) {
        if (collection.isGroup) {
          items.add(
            DropdownMenuItem<String?>(
              value: collection.id,
              child: Padding(
                padding: EdgeInsets.only(left: depth * 16.0),
                child: Text(collection.name),
              ),
            ),
          );

          // Añadir hijos recursivamente
          if (collection.children.isNotEmpty) {
            addCollectionItems(collection.children, depth + 1);
          }
        }
      }
    }

    // Añadir todas las colecciones (carpetas)
    addCollectionItems(widget.collections, 0);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        widget.initialName != null
            ? context.tr('collections.edit_endpoint')
            : context.tr('collections.new_endpoint'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del endpoint
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: context.tr('collections.endpoint_name'),
                hintText: context.tr('collections.endpoint_name_hint'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Selector de carpeta
            Text("Guardar en carpeta:"),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.black12 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _selectedParentId,
                  hint: Text("Seleccionar carpeta"),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedParentId = value;
                    });
                  },
                  items: _buildDropdownItems(),
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
          onPressed:
              _isValid
                  ? () {
                    widget.onSave(
                      _nameController.text.trim(),
                      widget.initialMethod ?? Method.get,
                      widget.initialPath ?? '',
                      _selectedParentId,
                    );
                    Navigator.pop(context);
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
