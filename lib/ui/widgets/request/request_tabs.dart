import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/ui/widgets/request/headers_editor.dart';
import 'package:nexust/ui/widgets/request/params_editor.dart';
import 'package:nexust/ui/widgets/request/body_editor.dart';

class RequestTabs extends StatefulWidget {
  const RequestTabs({super.key});

  @override
  State<RequestTabs> createState() => _RequestTabsState();
}

class _RequestTabsState extends State<RequestTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, String> _paramsData = {};
  final Map<String, String> _headersData = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  String _bodyData =
      '{\n  "name": "Nuevo Producto",\n  "price": 499.99,\n  "category": "electronics"\n}';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                      _paramsData.clear();
                      _paramsData.addAll(params);
                    });
                  },
                ),

                // Tab de Headers
                HeadersEditor(
                  initialHeaders: _headersData,
                  onHeadersChanged: (headers) {
                    setState(() {
                      _headersData.clear();
                      _headersData.addAll(headers);
                    });
                  },
                ),

                // Tab de Body
                BodyEditor(
                  initialBody: _bodyData,
                  onBodyChanged: (body) {
                    setState(() {
                      _bodyData = body;
                    });
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
