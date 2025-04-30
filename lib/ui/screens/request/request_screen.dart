import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/enums/request_status.dart';
import 'package:nexust/data/models/environment.dart';
import 'package:nexust/data/models/request_history_item.dart';
import 'package:nexust/presentation/blocs/request/request_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_state.dart';
import 'package:nexust/ui/widgets/request/http_method_selector.dart';
import 'package:nexust/ui/widgets/request/request_url_field.dart';
import 'package:nexust/ui/widgets/request/request_tabs.dart';
import 'package:nexust/ui/widgets/request/environment_selector.dart';
import 'package:nexust/ui/widgets/request/request_history.dart';
import 'package:nexust/ui/widgets/request/response_viewer_improved.dart';

class RequestScreen extends StatefulWidget {
  static const String routeName = "request";
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController _urlController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isUpdatingUrlFromState = false;
  bool _showHistory = false;

  // Lista de historial (en una app real, esto vendría de un repositorio)
  final List<RequestHistoryItem> _historyItems = [
    RequestHistoryItem(
      url: 'https://api.example.com/users',
      method: Method.get,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      statusCode: 200,
      isSuccess: true,
    ),
    RequestHistoryItem(
      url: 'https://api.example.com/products',
      method: Method.post,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      statusCode: 201,
      isSuccess: true,
    ),
    RequestHistoryItem(
      url: 'https://api.example.com/orders/123',
      method: Method.put,
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      statusCode: 400,
      isSuccess: false,
    ),
    RequestHistoryItem(
      url: 'https://api.example.com/auth/login',
      method: Method.post,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      statusCode: 401,
      isSuccess: false,
    ),
  ];

  // Lista de entornos de ejemplo (en una app real vendría de un repositorio)
  final List<Environment> _environments = [
    Environment(
      name: "Desarrollo",
      color: Colors.green,
      variables: {
        "BASE_URL": "https://dev-api.example.com",
        "API_KEY": "dev_api_key_123",
      },
    ),
    Environment(
      name: "Pruebas",
      color: Colors.blue,
      variables: {
        "BASE_URL": "https://staging-api.example.com",
        "API_KEY": "staging_api_key_456",
      },
    ),
    Environment(
      name: "Producción",
      color: Colors.red,
      variables: {
        "BASE_URL": "https://api.example.com",
        "API_KEY": "prod_api_key_789",
      },
    ),
  ];
  Environment? _selectedEnvironment;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      setState(() {
        _isCollapsed = _scrollController.offset > 80;
      });
    }
  }

  // Aplica las variables del entorno seleccionado a la URL
  String _processUrl(String url) {
    if (_selectedEnvironment == null) return url;

    String processedUrl = url;
    _selectedEnvironment!.variables.forEach((key, value) {
      processedUrl = processedUrl.replaceAll("{{$key}}", value);
    });

    return processedUrl;
  }

  void _applyEnvironmentUrl() {
    if (_selectedEnvironment == null) return;
    final baseUrl = _selectedEnvironment!.variables["BASE_URL"];
    if (baseUrl == null) return;

    if (_urlController.text.isEmpty) {
      _urlController.text = baseUrl;
      context.read<RequestCubit>().updateUrlWithParams(baseUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<RequestCubit, RequestState>(
      listenWhen:
          (previous, current) =>
              previous.request.url != current.request.url ||
              previous.status != current.status,
      listener: (context, state) {
        // Solo actualizar el controller si la URL cambió en el estado y no fue
        // por una actualización desde este widget
        if (_urlController.text != state.request.url &&
            !_isUpdatingUrlFromState) {
          _urlController.text = state.request.url;
        }

        // Guardar en historial cuando se completa una petición exitosa
        // if (previous.status != current.status &&
        //     current.status == RequestStatus.success) {
        //   _saveRequestToHistory(current);
        // }
      },
      builder: (context, state) {
        // Verificar si tenemos una respuesta para mostrar
        final bool hasResponse =
            state.status == RequestStatus.success && state.response != null;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // SliverAppBar con título dinámico
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 150.0,
                  backgroundColor: theme.appBarTheme.backgroundColor,
                  foregroundColor: theme.appBarTheme.foregroundColor,
                  title:
                      _isCollapsed
                          ? Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: state.request.method.color,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  state.request.method.stringName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  _urlController.text,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            _showHistory
                                ? "Historial de Peticiones"
                                : "Nueva Petición",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  actions: [
                    // Selector de entorno (visible cuando no está colapsado)
                    if (!_isCollapsed)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: EnvironmentSelector(
                          environments: _environments,
                          selectedEnvironment: _selectedEnvironment,
                          onEnvironmentSelected: (env) {
                            setState(() {
                              _selectedEnvironment = env;
                            });
                            _applyEnvironmentUrl();
                          },
                        ),
                      ),

                    // Botón de historial
                    IconButton(
                      icon: Icon(
                        _showHistory
                            ? FontAwesomeIcons.lightFileLines
                            : FontAwesomeIcons.lightClockRotateLeft,
                      ),
                      onPressed: () {
                        setState(() {
                          _showHistory = !_showHistory;
                        });
                      },
                      tooltip:
                          _showHistory ? "Nueva petición" : "Ver historial",
                    ),

                    // Botón de guardar
                    IconButton(
                      icon: Icon(FontAwesomeIcons.lightFloppyDisk),
                      onPressed: () {
                        _showSaveRequestDialog(context, state);
                      },
                      tooltip: "Guardar petición",
                    ),

                    // Botón de compartir
                    IconButton(
                      icon: Icon(FontAwesomeIcons.lightShareNodes),
                      onPressed: () {
                        _showShareOptions(context, state);
                      },
                      tooltip: "Compartir petición",
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        _isCollapsed
                            ? null
                            : Container(
                              padding: EdgeInsets.fromLTRB(
                                16.0,
                                90.0,
                                16.0,
                                0.0,
                              ),
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildRequestInputArea(context, state),
                                  SizedBox(height: 12),
                                  _buildSendButton(context, state),
                                ],
                              ),
                            ),
                  ),
                ),

                // Contenido principal (historial, tabs o respuesta)
                SliverFillRemaining(
                  child:
                      _showHistory
                          ? RequestHistory(
                            historyItems: _historyItems,
                            onItemSelected: (item) {
                              setState(() {
                                _showHistory = false;
                                // Cargar la petición seleccionada
                                _urlController.text = item.url;
                                context.read<RequestCubit>().updateMethod(
                                  item.method,
                                );
                                context
                                    .read<RequestCubit>()
                                    .updateUrlWithParams(item.url);
                              });
                            },
                          )
                          : hasResponse
                          ? ResponseViewerImproved(
                            responseData: state.response!.data,
                            responseHeaders: state.response!.headers,
                            statusCode: state.response!.statusCode,
                            responseTime: state.response!.responseTime,
                          )
                          : RequestTabs(
                            onParamsChanged: (params) {
                              context.read<RequestCubit>().updateQueryParams(
                                Map<String, dynamic>.from(params),
                              );
                            },
                            onHeadersChanged: (headers) {
                              context.read<RequestCubit>().updateHeaders(
                                headers,
                              );
                            },
                            onBodyChanged: (body) {
                              context.read<RequestCubit>().updateBody(body);
                            },
                            initialParams: state.request.queryParams.map(
                              (key, value) => MapEntry(key, value.toString()),
                            ),
                            initialHeaders: state.request.headers,
                            initialBody: state.request.body,
                          ),
                ),
              ],
            ),
            floatingActionButton:
                _showHistory
                    ? FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _showHistory = false;
                        });
                      },
                      backgroundColor: theme.primaryColor,
                      tooltip: "Nueva petición",
                      child: Icon(FontAwesomeIcons.lightPlus),
                    )
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildRequestInputArea(BuildContext context, RequestState state) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 40),
      child: Row(
        children: [
          HttpMethodSelector(
            selectedMethod: state.request.method,
            onMethodChanged: (method) {
              context.read<RequestCubit>().updateMethod(method);
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RequestUrlField(
              controller: _urlController,
              onSubmitted: (_) => _sendRequest(context),
              onChanged: (value) {
                _isUpdatingUrlFromState = true;
                context.read<RequestCubit>().updateUrlWithParams(value);
                _isUpdatingUrlFromState = false;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, RequestState state) {
    final isLoading = state.status == RequestStatus.loading;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 44),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _sendRequest(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: state.request.method.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child:
              isLoading
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    );
  }

  void _sendRequest(BuildContext context) {
    if (_urlController.text.isEmpty) {
      Toast.show("Por favor ingresa una URL");
      return;
    }

    // Procesar variables de entorno antes de enviar
    final processedUrl = _processUrl(_urlController.text);
    if (processedUrl != _urlController.text) {
      _isUpdatingUrlFromState = true;
      _urlController.text = processedUrl;
      context.read<RequestCubit>().updateUrlWithParams(processedUrl);
      _isUpdatingUrlFromState = false;
    }

    context.read<RequestCubit>().sendRequest();
  }

  void _showSaveRequestDialog(BuildContext context, RequestState state) {
    final theme = Theme.of(context);
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text("Guardar Petición"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre de la petición",
                    hintText: "Ej: Obtener usuarios",
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 16),
                Text(
                  "Se guardará la siguiente petición:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        theme.brightness == Brightness.dark
                            ? Colors.black12
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          theme.brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: state.request.method.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          state.request.method.stringName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _urlController.text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    Toast.show("Por favor ingresa un nombre para la petición");
                    return;
                  }

                  // Aquí se guardaría la petición (en una implementación real)
                  Toast.show("Petición guardada: ${nameController.text}");
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text("Guardar"),
              ),
            ],
          ),
    );
  }

  void _showShareOptions(BuildContext context, RequestState state) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder:
          (modalContext) => Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Compartir Petición",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightFileCode,
                      label: "Código",
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show("Exportar como código (por implementar)");
                      },
                    ),
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightFileExport,
                      label: "Exportar",
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show("Exportar petición (por implementar)");
                      },
                    ),
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightLink,
                      label: "Enlace",
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show("Generar enlace (por implementar)");
                      },
                    ),
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightShareNodes,
                      label: "Compartir",
                      color: theme.primaryColor,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show("Compartir (por implementar)");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightFileLines),
                  title: Text("Copiar como cURL"),
                  onTap: () {
                    Navigator.pop(modalContext);
                    Toast.show("Petición copiada como cURL (por implementar)");
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightCodeBranch),
                  title: Text("Generar código"),
                  subtitle: Text("JavaScript, Python, PHP, etc."),
                  onTap: () {
                    Navigator.pop(modalContext);
                    _showCodeGenerationDialog(context, state);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 70,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withAlpha((0.1 * 255).round()),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCodeGenerationDialog(BuildContext context, RequestState state) {
    final languages = [
      "JavaScript (Fetch)",
      "Python (Requests)",
      "cURL",
      "PHP",
      "Java",
      "C#",
      "Swift",
      "Go",
      "Ruby",
    ];

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text("Generar Código"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Selecciona el lenguaje:"),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(languages[index]),
                          onTap: () {
                            Navigator.pop(dialogContext);
                            Toast.show(
                              "Código generado en ${languages[index]} (por implementar)",
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text("Cancelar"),
              ),
            ],
          ),
    );
  }
}
