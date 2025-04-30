// lib/data/repositories/request_repository_impl.dart (modificado)

import 'package:nexust/data/services/http_service.dart';
import 'package:nexust/domain/entities/request_entity.dart';
import 'package:nexust/domain/entities/response_entity.dart';
import 'package:nexust/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final HttpService _httpService;

  RequestRepositoryImpl(this._httpService);

  @override
  Future<ResponseEntity> sendRequest(RequestEntity request) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;

    // Extraer URL base sin query params, ya que los pasaremos por separado
    String baseUrl = request.url;
    try {
      final Uri uri = Uri.parse(request.url);
      baseUrl = uri.origin + uri.path;
    } catch (e) {
      // Mantener la URL tal como está si no es válida
    }

    final response = await _httpService.request(
      url: baseUrl,
      method: request.method,
      queryParameters: request.queryParams,
      headers: request.headers,
      body: request.body,
      timeout: request.timeout,
    );

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final responseTime = endTime - startTime;

    return ResponseEntity(
      statusCode: response.statusCode ?? 500,
      statusMessage: response.statusMessage ?? '',
      data: response.data,
      headers: response.headers.map,
      responseTime: responseTime,
    );
  }
}
