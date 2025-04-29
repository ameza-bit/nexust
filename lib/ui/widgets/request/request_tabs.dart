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
  final dynamic initialBody;
  final Function(Map<String, String>) onParamsChanged;
  final Function(Map<String, String>) onHeadersChanged;
  final Function(dynamic) onBodyChanged;

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

  late Map<String, String> _paramsData;
  late Map<String, String> _headersData;
  late String _bodyData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Inicializar con valores proporcionados o valores predeterminados
    _paramsData =
        widget.initialParams != null
            ? _convertToStringMap(widget.initialParams!)
            : {};

    _headersData =
        widget.initialHeaders ??
        {'Content-Type': 'application/json', 'Accept': 'application/json'};

    _bodyData =
        widget.initialBody is String
            ? widget.initialBody
            : widget.initialBody != null
            ? jsonEncode(widget.initialBody)
            : '{\n  "name": "Nuevo Producto",\n  "price": 499.99,\n  "category": "electronics"\n}';
  }

  Map<String, String> _convertToStringMap(Map<String, dynamic> map) {
    Map<String, String> result = {};
    map.forEach((key, value) {
      result[key] = value.toString();
    });
    return result;
  }

  @override
  void didUpdateWidget(RequestTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Actualizar datos si cambian externamente
    if (widget.initialParams != oldWidget.initialParams &&
        widget.initialParams != null) {
      _paramsData = _convertToStringMap(widget.initialParams!);
    }

    if (widget.initialHeaders != oldWidget.initialHeaders &&
        widget.initialHeaders != null) {
      _headersData = widget.initialHeaders!;
    }

    if (widget.initialBody != oldWidget.initialBody &&
        widget.initialBody != null) {
      _bodyData =
          widget.initialBody is String
              ? widget.initialBody
              : jsonEncode(widget.initialBody);
    }
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
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

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
                  initialParams: _paramsData,
                  onParamsChanged: (params) {
                    setState(() {
                      _paramsData = params;
                    });
                    widget.onParamsChanged(params);
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
}
