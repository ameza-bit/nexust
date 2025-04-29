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

    final response = await _httpService.request(
      url: request.url,
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
