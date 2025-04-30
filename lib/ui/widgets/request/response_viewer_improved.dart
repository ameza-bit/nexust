import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';

class ResponseViewerImproved extends StatefulWidget {
  final Map<String, dynamic>? responseData;
  final Map<String, dynamic>? responseHeaders;
  final int statusCode;
  final int responseTime;

  const ResponseViewerImproved({
    super.key,
    required this.responseData,
    this.responseHeaders,
    required this.statusCode,
    required this.responseTime,
  });

  @override
  State<ResponseViewerImproved> createState() => _ResponseViewerImprovedState();
}

class _ResponseViewerImprovedState extends State<ResponseViewerImproved>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _prettyJson;
  late String _rawJson;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _formatResponse();
  }

  @override
  void didUpdateWidget(ResponseViewerImproved oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.responseData != oldWidget.responseData) {
      _formatResponse();
    }
  }

  void _formatResponse() {
    if (widget.responseData != null) {
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

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
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

    Widget content = Column(
      children: [
        // Response status bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black12 : Colors.grey.shade100,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Status code
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.statusCode),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.statusCode.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.scaleText(14),
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Response time
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.lightClock,
                    size: context.scaleIcon(14),
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "${widget.responseTime} ms",
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      fontSize: context.scaleText(14),
                    ),
                  ),
                ],
              ),

              Spacer(),

              // Fullscreen toggle
              IconButton(
                icon: Icon(
                  _isFullscreen
                      ? FontAwesomeIcons.lightCompress
                      : FontAwesomeIcons.lightExpand,
                  size: context.scaleIcon(16),
                ),
                onPressed: _toggleFullscreen,
                tooltip:
                    _isFullscreen
                        ? "Salir de pantalla completa"
                        : "Pantalla completa",
                splashRadius: 20,
              ),

              // Export button
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.lightDownload,
                  size: context.scaleIcon(16),
                ),
                onPressed: () {
                  // TODO: Implement export functionality
                  Toast.show("Exportar respuesta (por implementar)");
                },
                tooltip: "Exportar respuesta",
                splashRadius: 20,
              ),
            ],
          ),
        ),

        // TabBar for different response views
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
                text: "Body",
                icon: Icon(
                  FontAwesomeIcons.lightFileCode,
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
                text: "Preview",
                icon: Icon(
                  FontAwesomeIcons.lightEye,
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
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Body tab
              _buildPrettyView(),

              // Headers tab
              _buildHeadersView(),

              // Preview tab
              _buildPreviewView(),

              // Raw tab
              _buildRawView(),
            ],
          ),
        ),
      ],
    );

    if (_isFullscreen) {
      return Scaffold(body: SafeArea(child: content));
    } else {
      return content;
    }
  }

  Widget _buildPrettyView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // JSON viewer
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

        // Copy button
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

  Widget _buildHeadersView() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.responseHeaders == null || widget.responseHeaders!.isEmpty) {
      return Center(
        child: Text(
          "No hay headers disponibles",
          style: TextStyle(
            fontSize: context.scaleText(16),
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: widget.responseHeaders!.length,
            separatorBuilder:
                (context, index) => Divider(
                  height: 1,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
            itemBuilder: (context, index) {
              final entry = widget.responseHeaders!.entries.elementAt(index);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: context.scaleText(14),
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontSize: context.scaleText(14),
                          color: isDark ? Colors.white : Colors.black87,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Copy headers button
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed:
                () => _copyToClipboard(jsonEncode(widget.responseHeaders)),
            tooltip: 'Copiar headers',
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
        // Raw viewer
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

        // Copy button
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

  List<Widget> _buildPreviewItems(Object data, int depth) {
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
                      style: TextStyle(fontSize: context.scaleText(14)),
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
                    color:
                        isDark ? Colors.amber.shade300 : Colors.amber.shade700,
                  ),
                ),
                if (item is! Map && item is! List)
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: TextStyle(fontSize: context.scaleText(14)),
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

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green.shade700;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blue.shade700;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.amber.shade700;
    } else {
      return Colors.red.shade700;
    }
  }
}
