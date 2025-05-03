// lib/ui/screens/request/request_screen.dart (modificado)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/enums/request_status.dart';
import 'package:nexust/data/models/environment.dart';
import 'package:nexust/data/models/request_history_item.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/presentation/blocs/collections/collections_cubit.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nexust/presentation/widgets/request/http_method_selector.dart';
import 'package:nexust/presentation/widgets/request/request_url_field.dart';
import 'package:nexust/presentation/widgets/request/request_tabs.dart';
import 'package:nexust/presentation/widgets/request/environment_selector.dart';
import 'package:nexust/presentation/widgets/request/request_history.dart';
import 'package:nexust/presentation/widgets/request/response_viewer_improved.dart';

class RequestScreen extends StatefulWidget {
  static const String routeName = "request";
  final String? endpointId;
  final RestEndpoint? endpoint;

  const RequestScreen({super.key, this.endpointId, this.endpoint});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController _urlController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isUpdatingUrlFromState = false;
  bool _showHistory = false;
  RestEndpoint? _endpoint;
  bool _isDirty = false;
  bool _isSaving = false;

  // Lista de historial (en una app real, esto vendría de un repositorio)
  final List<RequestHistoryItem> _historyItems = [
    RequestHistoryItem(
      url: 'https://api.example.com/users',
      method: Method.get,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      statusCode: 200,
      isSuccess: true,
    ),
    // ... resto del historial
  ];

  // Lista de entornos de ejemplo (en una app real vendría de un repositorio)
  final List<Environment> _environments = [];

  Environment? _selectedEnvironment;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _endpoint = widget.endpoint;

    // Si recibimos un endpoint, inicializar la vista con sus datos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWithEndpoint();
    });
  }

  void _initializeWithEndpoint() {
    if (_endpoint != null) {
      final requestCubit = context.read<RequestCubit>();
      requestCubit.resetState();

      // Configurar URL y método
      _urlController.text = _endpoint!.path;
      requestCubit.updateMethod(_endpoint!.method);
      requestCubit.updateUrlWithParams(_endpoint!.path);

      // Configurar parámetros si existen
      if (_endpoint!.parameters != null) {
        requestCubit.updateQueryParams(_endpoint!.parameters!);
      }

      // Configurar headers si existen
      if (_endpoint!.headers != null) {
        requestCubit.updateHeaders(_endpoint!.headers!);
      }

      // Configurar body si existe
      if (_endpoint!.body != null) {
        requestCubit.updateBody(_endpoint!.body);
      }
    } else if (widget.endpointId != null && widget.endpointId!.isNotEmpty) {
      // En una implementación real, buscaríamos el endpoint por ID
      // Por ejemplo: _loadEndpointById(widget.endpointId!);
      // TODO: Implementar carga de endpoint por ID
      Toast.show("Cargar endpoint por ID no implementado");
    }
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

  // Aplicar variables del entorno seleccionado a la URL
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

    // Obtener la URL base de las variables del entorno seleccionado
    final baseUrl = _selectedEnvironment!.variables["API_URL"];
    if (baseUrl == null) {
      Toast.show("La variable API_URL no está definida en este entorno");
      return;
    }

    if (_urlController.text.isEmpty) {
      _urlController.text = baseUrl;
      context.read<RequestCubit>().updateUrlWithParams(baseUrl);
    }
  }

  // Guardar los cambios en el endpoint
  void _saveEndpoint() {
    if (_endpoint == null) return;

    setState(() {
      _isSaving = true;
    });

    final state = context.read<RequestCubit>().state;
    final collectionsBloc = context.read<CollectionsCubit>();

    // Crear una versión actualizada del endpoint
    final updatedEndpoint = _endpoint!.copyWith(
      method: state.request.method,
      path: state.request.url,
      parameters: state.request.queryParams,
      headers: state.request.headers,
      body: state.request.body,
      response: state.response?.data,
    );

    // Guardar el endpoint actualizado
    collectionsBloc.updateCollection(updatedEndpoint);

    // Actualizar el endpoint local
    setState(() {
      _endpoint = updatedEndpoint;
      _isDirty = false;
      _isSaving = false;
    });

    // Mostrar confirmación
    Toast.show(context.tr('collections.endpoint_saved'));
  }

  // Marca el endpoint como modificado
  void _markAsDirty() {
    if (_endpoint != null && !_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<RequestCubit, RequestState>(
      listenWhen:
          (previous, current) =>
              previous.request.url != current.request.url ||
              previous.status != current.status ||
              previous.request.method != current.request.method ||
              previous.request.queryParams != current.request.queryParams ||
              previous.request.headers != current.request.headers ||
              previous.request.body != current.request.body,
      listener: (context, state) {
        // Solo actualizar el controller si la URL cambió en el estado y no fue
        // por una actualización desde este widget
        if (_urlController.text != state.request.url &&
            !_isUpdatingUrlFromState) {
          _urlController.text = state.request.url;
        }

        // Si hay un endpoint cargado y hay cambios, marcar como dirty
        if (_endpoint != null) {
          if (state.request.method != _endpoint!.method ||
              state.request.url != _endpoint!.path ||
              state.request.queryParams != _endpoint!.parameters ||
              state.request.headers != _endpoint!.headers ||
              state.request.body != _endpoint!.body) {
            _markAsDirty();
          }
        }
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
                  automaticallyImplyLeading: false,
                  leading:
                      widget.endpointId == null
                          ? null
                          : IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
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
                            _endpoint != null
                                ? _endpoint!.name
                                : _showHistory
                                ? context.tr('request.history_title')
                                : context.tr('request.new_request'),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  actions: [
                    // Botón para guardar endpoint si existe
                    if (_endpoint != null && _isDirty && !_isCollapsed)
                      IconButton(
                        icon:
                            _isSaving
                                ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.appBarTheme.foregroundColor ??
                                          Colors.white,
                                    ),
                                  ),
                                )
                                : Icon(FontAwesomeIcons.lightFloppyDisk),
                        onPressed: _isSaving ? null : _saveEndpoint,
                        tooltip: context.tr('collections.save_endpoint'),
                      ),

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
                          _showHistory
                              ? context.tr('request.new')
                              : context.tr('request.view_history'),
                    ),

                    // Botón de guardar
                    IconButton(
                      icon: Icon(FontAwesomeIcons.lightFloppyDisk),
                      onPressed: () {
                        _showSaveRequestDialog(context, state);
                      },
                      tooltip: context.tr('request.save'),
                    ),

                    // Botón de compartir
                    IconButton(
                      icon: Icon(FontAwesomeIcons.lightShareNodes),
                      onPressed: () {
                        _showShareOptions(context, state);
                      },
                      tooltip: context.tr('request.share'),
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
                      tooltip: context.tr('request.new'),
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
                    context.tr('request.send'),
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
      Toast.show(context.tr('request.url_empty'));
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
    final projectCubit = context.read<ProjectCubit>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.tr('request.save_dialog_title')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: context.tr('request.request_name'),
                    hintText: context.tr('request.request_name_hint'),
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 16),
                Text(
                  context.tr('request.save_dialog_description'),
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
                child: Text(context.tr('common.cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    Toast.show(context.tr('request.name_required'));
                    return;
                  }

                  // Obtener el proyecto actual
                  final currentProject = projectCubit.state.currentProject;
                  if (currentProject == null) {
                    Toast.show('No hay un proyecto seleccionado');
                    return;
                  }

                  // Crear un nuevo endpoint o colección
                  final endpoint = RestEndpoint(
                    name: nameController.text.trim(),
                    isGroup: false,
                    method: state.request.method,
                    path: state.request.url,
                    parameters: state.request.queryParams,
                    headers: state.request.headers,
                    body: state.request.body,
                    projectId: currentProject.id, // Añadir projectId aquí
                  );

                  // Guardar el endpoint
                  context.read<CollectionsCubit>().addCollection(endpoint);

                  Navigator.pop(dialogContext);
                  Toast.show(context.tr('request.saved_successfully'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.tr('common.save')),
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
                  context.tr('request.share_title'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightFileCode,
                      label: context.tr('request.share_as_code'),
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show(context.tr('request.share_not_implemented'));
                      },
                    ),
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightFileExport,
                      label: context.tr('request.export'),
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show(context.tr('request.share_not_implemented'));
                      },
                    ),
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightLink,
                      label: context.tr('request.share_as_link'),
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show(context.tr('request.share_not_implemented'));
                      },
                    ),
                    _buildShareOption(
                      icon: FontAwesomeIcons.lightShareNodes,
                      label: context.tr('common.share'),
                      color: theme.primaryColor,
                      onTap: () {
                        Navigator.pop(modalContext);
                        Toast.show(context.tr('request.share_not_implemented'));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightFileLines),
                  title: Text(context.tr('request.copy_as_curl')),
                  onTap: () {
                    Navigator.pop(modalContext);
                    Toast.show(context.tr('request.share_not_implemented'));
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.lightCodeBranch),
                  title: Text(context.tr('request.generate_code')),
                  subtitle: Text(context.tr('request.generate_code_desc')),
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
            title: Text(context.tr('request.generate_code')),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.tr('request.select_language')),
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
                              context.tr(
                                'request.code_generated_language',
                                namedArgs: {'language': languages[index]},
                              ),
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
                child: Text(context.tr('common.cancel')),
              ),
            ],
          ),
    );
  }
}
