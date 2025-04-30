import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/ui/widgets/request/headers_editor.dart';
import 'package:nexust/ui/widgets/request/params_editor.dart';
import 'package:nexust/ui/widgets/request/body_editor.dart';

class RequestTabs extends StatefulWidget {
  final Map<String, dynamic>? initialParams;
  final Map<String, String>? initialHeaders;
  final Object? initialBody;
  final Function(Map<String, dynamic>) onParamsChanged;
  final Function(Map<String, String>) onHeadersChanged;
  final Function(Object?) onBodyChanged;

  const RequestTabs({
    super.key,
    this.initialParams,
    this.initialHeaders,
    this.initialBody,
    required this.onParamsChanged,
    required this.onHeadersChanged,
    required this.onBodyChanged,
  });

  @override
  State<RequestTabs> createState() => _RequestTabsState();
}

class _RequestTabsState extends State<RequestTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Map<String, dynamic> _paramsData;
  late Map<String, String> _headersData;
  late String _bodyData;
  bool _isUpdatingParams = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Inicializar con valores proporcionados o valores predeterminados
    _paramsData = widget.initialParams ?? {};

    _headersData =
        widget.initialHeaders ??
        {'Content-Type': 'application/json', 'Accept': 'application/json'};

    _bodyData =
        widget.initialBody is String
            ? widget.initialBody as String
            : widget.initialBody != null
            ? jsonEncode(widget.initialBody)
            : '{\n  "name": "Nuevo Producto",\n  "price": 499.99,\n  "category": "electronics"\n}';
  }

  @override
  void didUpdateWidget(RequestTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Actualizar datos si cambian externamente y no estamos en el proceso de actualización
    if (!_isUpdatingParams &&
        widget.initialParams != null &&
        !mapEquals(widget.initialParams, _paramsData)) {
      setState(() {
        _paramsData = Map<String, dynamic>.from(widget.initialParams!);
      });
    }

    if (widget.initialHeaders != null &&
        !mapEquals(widget.initialHeaders, _headersData)) {
      setState(() {
        _headersData = Map<String, String>.from(widget.initialHeaders!);
      });
    }

    if (widget.initialBody != oldWidget.initialBody &&
        widget.initialBody != null) {
      setState(() {
        _bodyData =
            widget.initialBody is String
                ? widget.initialBody as String
                : jsonEncode(widget.initialBody);
      });
    }
  }

  // Helper para comparar mapas
  bool mapEquals<T, U>(Map<T, U>? a, Map<T, U>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }

    return true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TabBar para las diferentes secciones
          Container(
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: theme.primaryColor,
              unselectedLabelColor:
                  isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              indicatorColor: theme.primaryColor,
              indicatorWeight: 3,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: context.scaleText(14),
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: context.scaleText(14),
              ),
              tabs: [
                Tab(
                  text: "Params",
                  icon: Icon(
                    FontAwesomeIcons.lightListOl,
                    size: context.scaleIcon(16),
                  ),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  text: "Headers",
                  icon: Icon(
                    FontAwesomeIcons.lightHeading,
                    size: context.scaleIcon(16),
                  ),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  text: "Body",
                  icon: Icon(
                    FontAwesomeIcons.lightBracketsCurly,
                    size: context.scaleIcon(16),
                  ),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
              ],
            ),
          ),

          // Contenido de los tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab de Params
                ParamsEditor(
                  initialParams: _convertToStringMap(_paramsData),
                  onParamsChanged: (params) {
                    _isUpdatingParams = true;
                    final dynamicParams = _convertStringMapToDynamicMap(params);
                    setState(() {
                      _paramsData = dynamicParams;
                    });
                    widget.onParamsChanged(dynamicParams);
                    _isUpdatingParams = false;
                  },
                ),

                // Tab de Headers
                HeadersEditor(
                  initialHeaders: _headersData,
                  onHeadersChanged: (headers) {
                    setState(() {
                      _headersData = headers;
                    });
                    widget.onHeadersChanged(headers);
                  },
                ),

                // Tab de Body
                BodyEditor(
                  initialBody: _bodyData,
                  onBodyChanged: (body) {
                    setState(() {
                      _bodyData = body;
                    });
                    widget.onBodyChanged(body);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Convertir de Map<String, dynamic> a Map<String, String>
  Map<String, String> _convertToStringMap(Map<String, dynamic> map) {
    Map<String, String> result = {};
    map.forEach((key, value) {
      result[key] = value.toString();
    });
    return result;
  }

  // Convertir de Map<String, String> a Map<String, dynamic>
  Map<String, dynamic> _convertStringMapToDynamicMap(Map<String, String> map) {
    Map<String, dynamic> result = {};
    map.forEach((key, value) {
      // Intentar convertir a tipos primitivos si es posible
      if (value == 'true') {
        result[key] = true;
      } else if (value == 'false') {
        result[key] = false;
      } else if (int.tryParse(value) != null) {
        result[key] = int.parse(value);
      } else if (double.tryParse(value) != null) {
        result[key] = double.parse(value);
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}
