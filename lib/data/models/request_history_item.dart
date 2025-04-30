import 'package:nexust/data/enums/method.dart';

class RequestHistoryItem {
  final String url;
  final Method method;
  final DateTime timestamp;
  final int statusCode;
  final bool isSuccess;

  RequestHistoryItem({
    required this.url,
    required this.method,
    required this.timestamp,
    required this.statusCode,
    required this.isSuccess,
  });
}
