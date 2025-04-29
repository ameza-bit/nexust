import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';

class ResponseViewer extends StatefulWidget {
  final Map<String, dynamic>? responseData;

  const ResponseViewer({
    super.key,
    required this.responseData,
  });

  @override
  State<ResponseViewer> createState() => _ResponseViewerState();
}

class _ResponseViewerState extends State<ResponseViewer> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _prettyJson;
  late String _rawJson;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _formatResponse();
  }

  @override
  void didUpdateWidget(ResponseViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.responseData != oldWidget.responseData) {
      _formatResponse();
    }
  }

  void _formatResponse() {
    if (widget.responseData != null) {
      // En una app real, usaríamos un formateo más robusto
      const encoder = JsonEncoder.withIndent('  ');
      _prettyJson = encoder.convert(widget.responseData!);
      _rawJson = jsonEncode(widget.responseData!);
    } else {
      _prettyJson = '';
      _rawJson = '';
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Toast.show("Copiado al portapapeles");
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

    return Column(
      children: [
        // TabBar para diferentes vistas de la respuesta
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
            unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
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
                text: "Pretty",
                icon: Icon(
                  FontAwesomeIcons.lightFileCode,
                  size: context.scaleIcon(16),
                ),
                iconMargin: const EdgeInsets.only(bottom: 4),
              ),
              Tab(
                text: "Raw",
                icon: Icon(
                  FontAwesomeIcons.lightFileLines,
                  size: context.scaleIcon(16),
                ),
                iconMargin: const EdgeInsets.only(bottom: 4),
              ),
              Tab(
                text: "Preview",
                icon: Icon(
                  FontAwesomeIcons.lightEye,
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
              // Pretty JSON
              _buildPrettyView(),
              
              // Raw JSON
              _buildRawView(),
              
              // Preview
              _buildPreviewView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrettyView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Visualizador JSON
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              _prettyJson,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: context.scaleText(13),
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade900,
              ),
            ),
          ),
        ),
        
        // Botón de copiar
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => _copyToClipboard(_prettyJson),
            tooltip: 'Copiar JSON',
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.lightCopy,
              size: context.scaleIcon(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRawView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Visualizador Raw
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              _rawJson,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: context.scaleText(13),
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade900,
              ),
            ),
          ),
        ),
        
        // Botón de copiar
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => _copyToClipboard(_rawJson),
            tooltip: 'Copiar texto',
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.lightCopy,
              size: context.scaleIcon(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.responseData == null) {
      return Center(
        child: Text(
          "No hay datos para visualizar",
          style: TextStyle(
            fontSize: context.scaleText(16),
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildPreviewItems(widget.responseData!, 0),
      ),
    );
  }

  List<Widget> _buildPreviewItems(dynamic data, int depth) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final List<Widget> widgets = [];
    
    if (data is Map) {
      data.forEach((key, value) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: depth * 16.0, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$key: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.scaleText(14),
                    color: theme.primaryColor,
                  ),
                ),
                if (value is! Map && value is! List)
                  Expanded(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: context.scaleText(14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
        
        if (value is Map || value is List) {
          widgets.addAll(_buildPreviewItems(value, depth + 1));
        }
      });
    } else if (data is List) {
      for (var i = 0; i < data.length; i++) {
        final item = data[i];
        
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: depth * 16.0, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[$i]: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.scaleText(14),
                    color: isDark ? Colors.amber.shade300 : Colors.amber.shade700,
                  ),
                ),
                if (item is! Map && item is! List)
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                        fontSize: context.scaleText(14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
        
        if (item is Map || item is List) {
          widgets.addAll(_buildPreviewItems(item, depth + 1));
        }
      }
    }
    
    return widgets;
  }
}