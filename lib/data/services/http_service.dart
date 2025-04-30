import 'package:dio/dio.dart';
import 'package:nexust/data/enums/method.dart';

class HttpService {
  final Dio _dio;

  HttpService() : _dio = Dio() {
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  Future<Response> request({
    required String url,
    required Method method,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    int timeout = 30000,
  }) async {
    _dio.options.headers = headers;
    _dio.options.connectTimeout = Duration(milliseconds: timeout);
    _dio.options.receiveTimeout = Duration(milliseconds: timeout);

    try {
      Response response;
      switch (method) {
        case Method.get:
          response = await _dio.get(url, queryParameters: queryParameters);
          break;
        case Method.post:
          response = await _dio.post(url, data: body, queryParameters: queryParameters);
          break;
        case Method.put:
          response = await _dio.put(url, data: body, queryParameters: queryParameters);
          break;
        case Method.delete:
          response = await _dio.delete(url, data: body, queryParameters: queryParameters);
          break;
        case Method.patch:
          response = await _dio.patch(url, data: body, queryParameters: queryParameters);
          break;
        case Method.head:
          response = await _dio.head(url, queryParameters: queryParameters);
          break;
        case Method.options:
          // TODO: Handle Options case.
          response = await _dio.get(url, queryParameters: queryParameters);
          break;
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        return Response(
          statusCode: e.response?.statusCode ?? 500,
          statusMessage: e.message,
          requestOptions: RequestOptions(path: url),
          data: e.response?.data,
        );
      }
      return Response(
        statusCode: 500,
        statusMessage: e.toString(),
        requestOptions: RequestOptions(path: url),
      );
    }
  }
}