import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/enums/request_status.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/presentation/blocs/collections/collections_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_state.dart';
import 'package:nexust/presentation/widgets/request/http_method_selector.dart';
import 'package:nexust/presentation/widgets/request/request_tabs.dart';
import 'package:nexust/presentation/widgets/request/request_url_field.dart';
import 'package:nexust/presentation/widgets/request/response_viewer_improved.dart';

class RequestDetailScreen extends StatefulWidget {
  static const String routeName = 'request-detail';
  final RestEndpoint endpoint;

  const RequestDetailScreen({super.key, required this.endpoint});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  late TextEditingController _urlController;
  late RestEndpoint _endpoint;
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _endpoint = widget.endpoint;
    _urlController = TextEditingController(text: _endpoint.path);

    // Inicializar el estado de la petición con los datos del endpoint
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<RequestCubit>();
      request.resetState();
      request.updateMethod(_endpoint.method);
      request.updateUrlWithParams(_endpoint.path);

      if (_endpoint.parameters != null) {
        request.updateQueryParams(_endpoint.parameters!);
      }

      if (_endpoint.headers != null) {
        request.updateHeaders(_endpoint.headers!);
      }

      if (_endpoint.body != null) {
        request.updateBody(_endpoint.body);
      }
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() {
      _isSaving = true;
    });

    final requestState = context.read<RequestCubit>().state;

    // Actualizar el endpoint con los datos actuales
    final updatedEndpoint = _endpoint.copyWith(
      method: requestState.request.method,
      path: requestState.request.url,
      parameters: requestState.request.queryParams,
      headers: requestState.request.headers,
      body: requestState.request.body,
      response: requestState.response?.data,
    );

    // Guardar el endpoint actualizado
    await context.read<CollectionsCubit>().updateCollection(updatedEndpoint);

    setState(() {
      _endpoint = updatedEndpoint;
      _isDirty = false;
      _isSaving = false;
    });
  }

  void _onRequestStateChanged() {
    setState(() {
      _isDirty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_endpoint.name),
        actions: [
          if (_isDirty)
            IconButton(
              icon:
                  _isSaving
                      ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.appBarTheme.foregroundColor ?? Colors.white,
                          ),
                        ),
                      )
                      : Icon(FontAwesomeIcons.lightFloppyDisk),
              onPressed: _isSaving ? null : _save,
              tooltip: 'Guardar cambios',
            ),
          IconButton(
            icon: Icon(FontAwesomeIcons.lightCirclePlay),
            onPressed: () {
              context.read<RequestCubit>().sendRequest();
            },
            tooltip: 'Ejecutar petición',
          ),
          PopupMenuButton<String>(
            icon: Icon(FontAwesomeIcons.lightEllipsisVertical),
            onSelected: (value) {
              if (value == 'duplicate') {
                final cubit = context.read<CollectionsCubit>();
                cubit.duplicateCollection(_endpoint);
                Navigator.pop(context);
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.lightCopy, size: 16),
                        SizedBox(width: 8),
                        Text('Duplicar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.lightTrash,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Area de entrada de la petición
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // URL y método
                Row(
                  children: [
                    BlocConsumer<RequestCubit, RequestState>(
                      listenWhen:
                          (previous, current) =>
                              previous.request.method != current.request.method,
                      listener: (context, state) {
                        _onRequestStateChanged();
                      },
                      builder: (context, state) {
                        return HttpMethodSelector(
                          selectedMethod: state.request.method,
                          onMethodChanged: (method) {
                            context.read<RequestCubit>().updateMethod(method);
                          },
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: BlocConsumer<RequestCubit, RequestState>(
                        listenWhen:
                            (previous, current) =>
                                previous.request.url != current.request.url,
                        listener: (context, state) {
                          if (_urlController.text != state.request.url) {
                            _urlController.text = state.request.url;
                          }
                          _onRequestStateChanged();
                        },
                        builder: (context, state) {
                          return RequestUrlField(
                            controller: _urlController,
                            onSubmitted:
                                (_) =>
                                    context.read<RequestCubit>().sendRequest(),
                            onChanged: (value) {
                              context.read<RequestCubit>().updateUrlWithParams(
                                value,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Botón de enviar
                SizedBox(height: 12),
                BlocBuilder<RequestCubit, RequestState>(
                  builder: (context, state) {
                    final isLoading = state.status == RequestStatus.loading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  context.read<RequestCubit>().sendRequest();
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.request.method.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                    );
                  },
                ),
              ],
            ),
          ),

          // Línea divisoria
          Divider(height: 1),

          // Tabs o respuesta
          Expanded(
            child: BlocConsumer<RequestCubit, RequestState>(
              listenWhen:
                  (previous, current) =>
                      previous.request.queryParams !=
                          current.request.queryParams ||
                      previous.request.headers != current.request.headers ||
                      previous.request.body != current.request.body,
              listener: (context, state) {
                _onRequestStateChanged();
              },
              builder: (context, state) {
                final hasResponse =
                    state.status == RequestStatus.success &&
                    state.response != null;

                if (hasResponse) {
                  return ResponseViewerImproved(
                    responseData: state.response!.data,
                    responseHeaders: state.response!.headers,
                    statusCode: state.response!.statusCode,
                    responseTime: state.response!.responseTime,
                  );
                } else {
                  return RequestTabs(
                    onParamsChanged: (params) {
                      context.read<RequestCubit>().updateQueryParams(
                        Map<String, dynamic>.from(params),
                      );
                    },
                    onHeadersChanged: (headers) {
                      context.read<RequestCubit>().updateHeaders(headers);
                    },
                    onBodyChanged: (body) {
                      context.read<RequestCubit>().updateBody(body);
                    },
                    initialParams: state.request.queryParams.map(
                      (key, value) => MapEntry(key, value.toString()),
                    ),
                    initialHeaders: state.request.headers,
                    initialBody: state.request.body,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Eliminar endpoint'),
            content: Text(
              '¿Estás seguro de que deseas eliminar "${_endpoint.name}"? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  context.read<CollectionsCubit>().deleteCollection(
                    _endpoint.id,
                  );
                  Navigator.pop(
                    context,
                  ); // Regresa a la pantalla de colecciones
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
