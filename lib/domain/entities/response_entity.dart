class ResponseEntity {
  final int statusCode;
  final String statusMessage;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? headers;
  final int responseTime;

  ResponseEntity({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
    this.headers,
    required this.responseTime,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
