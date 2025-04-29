import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class HeadersEditor extends StatefulWidget {
  final Map<String, String> initialHeaders;
  final Function(Map<String, String>) onHeadersChanged;

  const HeadersEditor({
    super.key,
    required this.initialHeaders,
    required this.onHeadersChanged,
  });

  @override
  State<HeadersEditor> createState() => _HeadersEditorState();
}

class _HeadersEditorState extends State<HeadersEditor> {
  late List<_HeaderItem> _headers;
  final Map<String, String> _commonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ',
    'Cache-Control': 'no-cache',
    'User-Agent': 'Nexust/1.0',
    'Accept-Language': 'es-MX',
    'X-Requested-With': 'XMLHttpRequest',
  };

  @override
  void initState() {
    super.initState();
    _initHeaders();
  }

  void _initHeaders() {
    _headers = [];
    
    // Si no hay headers iniciales, agregar uno vacío
    if (widget.initialHeaders.isEmpty) {
      _headers.add(_HeaderItem(key: '', value: '', enabled: true));
    } else {
      // Convertir los headers iniciales a items
      widget.initialHeaders.forEach((key, value) {
        _headers.add(_HeaderItem(key: key, value: value, enabled: true));
      });
    }
  }

  void _addHeader() {
    setState(() {
      _headers.add(_HeaderItem(key: '', value: '', enabled: true));
    });
  }

  void _addCommonHeader(String key, String value) {
    // Verificar si el header ya existe
    final existingIndex = _headers.indexWhere((h) => h.key == key);
    
    if (existingIndex != -1) {
      // Si existe, simplemente actualizarlo y habilitarlo
      setState(() {
        _headers[existingIndex].value = value;
        _headers[existingIndex].enabled = true;
        _updateHeaders();
      });
    } else {
      // Si no existe, agregar uno nuevo
      setState(() {
        _headers.add(_HeaderItem(key: key, value: value, enabled: true));
        _updateHeaders();
      });
    }
  }

  void _removeHeader(int index) {
    setState(() {
      _headers.removeAt(index);
      _updateHeaders();
    });
  }

  void _updateHeader(int index, {String? key, String? value, bool? enabled}) {
    setState(() {
      if (key != null) _headers[index].key = key;
      if (value != null) _headers[index].value = value;
      if (enabled != null) _headers[index].enabled = enabled;
      _updateHeaders();
    });
  }

  void _updateHeaders() {
    final Map<String, String> updatedHeaders = {};
    
    for (var header in _headers) {
      if (header.enabled && header.key.isNotEmpty) {
        updatedHeaders[header.key] = header.value;
      }
    }
    
    widget.onHeadersChanged(updatedHeaders);
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
            "Headers de la petición",
            style: TextStyle(
              fontSize: context.scaleText(16),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Configura los encabezados que se enviarán con la petición",
            style: TextStyle(
              fontSize: context.scaleText(14),
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          
          // Headers comunes
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _commonHeaders.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: context.scaleText(12),
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    onPressed: () => _addCommonHeader(entry.key, entry.value),
                  ),
                );
              }).toList(),
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
                    "NOMBRE",
                    style: TextStyle(
                      fontSize: context.scaleText(12),
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
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
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Espacio para el botón de eliminar
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Lista de headers
          Expanded(
            child: ListView.builder(
              itemCount: _headers.length,
              itemBuilder: (context, index) {
                final header = _headers[index];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      // Checkbox para habilitar/deshabilitar
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: header.enabled,
                          onChanged: (value) {
                            _updateHeader(index, enabled: value);
                          },
                          activeColor: theme.primaryColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      
                      // Campo para la clave
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black12 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: TextEditingController(text: header.key),
                            onChanged: (value) {
                              _updateHeader(index, key: value);
                            },
                            style: TextStyle(
                              fontSize: context.scaleText(14),
                              color: header.enabled
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nombre del header',
                              hintStyle: TextStyle(
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                fontSize: context.scaleText(14),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: InputBorder.none,
                            ),
                            enabled: header.enabled,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Campo para el valor
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black12 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: TextEditingController(text: header.value),
                            onChanged: (value) {
                              _updateHeader(index, value: value);
                            },
                            style: TextStyle(
                              fontSize: context.scaleText(14),
                              color: header.enabled
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Valor del header',
                              hintStyle: TextStyle(
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                fontSize: context.scaleText(14),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: InputBorder.none,
                            ),
                            enabled: header.enabled,
                          ),
                        ),
                      ),
                      
                      // Botón para eliminar
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.lightTrash,
                          size: context.scaleIcon(16),
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        onPressed: () => _removeHeader(index),
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
          
          // Botón para agregar header
          TextButton.icon(
            onPressed: _addHeader,
            icon: Icon(
              FontAwesomeIcons.lightPlus,
              size: context.scaleIcon(16),
              color: theme.primaryColor,
            ),
            label: Text(
              "Agregar header",
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

class _HeaderItem {
  String key;
  String value;
  bool enabled;

  _HeaderItem({
    required this.key,
    required this.value,
    required this.enabled,
  });
}