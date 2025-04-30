import 'package:nexust/data/enums/method.dart';

class RequestEntity {
  final String url;
  final Method method;
  final Map<String, dynamic> queryParams;
  final Map<String, String> headers;
  final Object? body;
  final int timeout;

  RequestEntity({
    required this.url,
    required this.method,
    this.queryParams = const {},
    this.headers = const {},
    this.body,
    this.timeout = 30000,
  });

  RequestEntity copyWith({
    String? url,
    Method? method,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Object? body,
    int? timeout,
  }) {
    return RequestEntity(
      url: url ?? this.url,
      method: method ?? this.method,
      queryParams: queryParams ?? this.queryParams,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      timeout: timeout ?? this.timeout,
    );
  }
}
