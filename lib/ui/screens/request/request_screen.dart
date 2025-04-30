import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/presentation/blocs/request/request_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_state.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isUpdatingUrlFromState = false;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<RequestCubit, RequestState>(
      listenWhen:
          (previous, current) => previous.request.url != current.request.url,
      listener: (context, state) {
        // Solo actualizar el controller si la URL cambió en el estado y no fue
        // por una actualización desde este widget
        if (_urlController.text != state.request.url &&
            !_isUpdatingUrlFromState) {
          _urlController.text = state.request.url;
        }
      },
      builder: (context, state) {
        // Verificar si tenemos una respuesta para mostrar
        final bool hasResponse =
            state.status == RequestStatus.success && state.response != null;
        final bool isLoading = state.status == RequestStatus.loading;

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
                            "Nueva Petición",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
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

                // Contenido principal (tabs o respuesta)
                SliverFillRemaining(
                  child:
                      hasResponse
                          ? _buildResponseSection(context, state)
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
            floatingActionButton: null,
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

    context.read<RequestCubit>().sendRequest();
  }

  Widget _buildResponseSection(BuildContext context, RequestState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final response = state.response!;

    return Column(
      children: [
        // Información de respuesta (status, tiempo)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(response.statusCode.toString()),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  response.statusCode.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.scaleText(14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${response.responseTime} ms",
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  fontSize: context.scaleText(14),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Volver a la sección de configuración
                  context.read<RequestCubit>().emit(
                    state.copyWith(status: RequestStatus.initial),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.lightPenToSquare,
                  size: context.scaleIcon(16),
                ),
                label: Text(
                  "Editar",
                  style: TextStyle(fontSize: context.scaleText(14)),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),

        // Visor de respuesta
        Expanded(child: ResponseViewer(responseData: response.data)),
      ],
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
