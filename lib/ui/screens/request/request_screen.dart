import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/ui/widgets/request/http_method_selector.dart';
import 'package:nexust/ui/widgets/request/request_url_field.dart';
import 'package:nexust/ui/widgets/request/request_tabs.dart';
import 'package:nexust/ui/widgets/request/response_viewer.dart';

class RequestScreen extends StatefulWidget {
  static const String routeName = "request";
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController _urlController = TextEditingController();
  Method _selectedMethod = Method.get;
  bool _isLoading = false;
  bool _hasResponse = false;
  Map<String, dynamic>? _responseData;
  String _responseStatus = "200";
  String _responseTime = "154 ms";

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _sendRequest() async {
    if (_urlController.text.isEmpty) {
      Toast.show("Por favor ingresa una URL");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulación de una petición
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _hasResponse = true;
      _responseData = {
        "id": 1,
        "name": "Producto de ejemplo",
        "price": 299.99,
        "category": "electronics",
        "stock": 25,
        "description":
            "Este es un producto de ejemplo para mostrar la respuesta de la API",
        "features": [
          "Característica 1",
          "Característica 2",
          "Característica 3",
        ],
        "rating": {"average": 4.5, "count": 120},
        "created_at": "2025-04-26T14:20:00Z",
        "updated_at": "2025-04-29T09:15:00Z",
      };
    });

    Toast.show("Petición enviada con éxito");
  }

  void _onMethodChanged(Method method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Nueva Petición",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.lightFloppyDisk),
              onPressed: () {
                // TODO: Implementar guardado de la petición
                Toast.show("Add logic for 'Guardar petición'");
              },
              tooltip: "Guardar petición",
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.lightShareNodes),
              onPressed: () {
                // TODO: Implementar compartir petición
                Toast.show("Add logic for 'Compartir petición'");
              },
              tooltip: "Compartir petición",
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Sección para URL y método
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: isDark ? theme.cardColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Selector de método y campo de URL
                    Row(
                      children: [
                        HttpMethodSelector(
                          selectedMethod: _selectedMethod,
                          onMethodChanged: _onMethodChanged,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RequestUrlField(
                            controller: _urlController,
                            onSubmitted: (_) => _sendRequest(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Botón de enviar petición
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedMethod.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  "Enviar",
                                  style: TextStyle(
                                    fontSize: context.scaleText(16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs para configuración y visualización
              Expanded(
                child:
                    _hasResponse
                        ? Column(
                          children: [
                            // Información de respuesta (status, tiempo)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? Colors.black12
                                        : Colors.grey.shade100,
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        isDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(_responseStatus),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _responseStatus,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: context.scaleText(14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _responseTime,
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade700,
                                      fontSize: context.scaleText(14),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      // Volver a la sección de configuración
                                      setState(() {
                                        _hasResponse = false;
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.lightPenToSquare,
                                      size: context.scaleIcon(16),
                                    ),
                                    label: Text(
                                      "Editar",
                                      style: TextStyle(
                                        fontSize: context.scaleText(14),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Visor de respuesta
                            Expanded(
                              child: ResponseViewer(
                                responseData: _responseData,
                              ),
                            ),
                          ],
                        )
                        : RequestTabs(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    final statusCode = int.tryParse(status.split(' ')[0]) ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green.shade700;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blue.shade700;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.amber.shade700;
    } else if (statusCode >= 500) {
      return Colors.red.shade700;
    }

    return Colors.grey.shade700;
  }
}
