import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/domain/entities/request_entity.dart';
import 'package:nexust/domain/repositories/request_repository.dart';
import 'package:nexust/presentation/blocs/request/request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  final RequestRepository _requestRepository;

  RequestCubit(this._requestRepository) : super(RequestState.initial());

  // Actualiza la URL completa y extrae/sincroniza los parámetros
  void updateUrlWithParams(String fullUrl) {
    if (fullUrl.isEmpty) {
      emit(
        state.copyWith(
          request: state.request.copyWith(url: fullUrl, queryParams: {}),
        ),
      );
      return;
    }

    try {
      final Uri uri = Uri.parse(fullUrl);
      final String baseUrl = uri.origin + uri.path;
      final Map<String, dynamic> extractedParams = uri.queryParameters.map(
        (key, value) => MapEntry(key, value),
      );

      // Actualizamos tanto la URL como los parámetros extraídos
      emit(
        state.copyWith(
          request: state.request.copyWith(
            url: fullUrl,
            queryParams: extractedParams,
          ),
        ),
      );
    } catch (e) {
      // Si la URL no es válida, solo actualizamos la URL sin tocar los parámetros
      emit(state.copyWith(request: state.request.copyWith(url: fullUrl)));
    }
  }

  void updateMethod(Method method) {
    emit(state.copyWith(request: state.request.copyWith(method: method)));
  }

  // Actualiza los parámetros y sincroniza con la URL
  void updateQueryParams(Map<String, dynamic> queryParams) {
    // Extraer la parte base de la URL actual
    String baseUrl = state.request.url;
    try {
      final Uri uri = Uri.parse(state.request.url);
      baseUrl = uri.origin + uri.path;
    } catch (e) {
      // Si la URL no es válida, mantenerla como está
    }

    // Actualizar tanto los parámetros como la URL
    emit(
      state.copyWith(
        request: state.request.copyWith(
          queryParams: queryParams,
          url: _buildUrlWithParams(baseUrl, queryParams),
        ),
      ),
    );
  }

  // Método auxiliar para construir URL con parámetros
  String _buildUrlWithParams(String baseUrl, Map<String, dynamic> params) {
    if (params.isEmpty) return baseUrl;

    final Uri baseUri = Uri.parse(baseUrl);
    final Uri newUri = baseUri.replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    return newUri.toString();
  }

  void updateHeaders(Map<String, String> headers) {
    emit(state.copyWith(request: state.request.copyWith(headers: headers)));
  }

  void updateBody(dynamic body) {
    emit(state.copyWith(request: state.request.copyWith(body: body)));
  }

  Future<void> sendRequest() async {
    if (state.request.url.isEmpty) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          errorMessage: 'URL cannot be empty',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading));

    try {
      final response = await _requestRepository.sendRequest(state.request);
      emit(state.copyWith(response: response, status: RequestStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: RequestStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void resetState() {
    emit(RequestState.initial());
  }
}
