class RestEndpoint {
  final String name;
  final bool isGroup;
  final String method; // GET, POST, PUT, DELETE, etc.
  final String path;
  final Map<String, dynamic>? parameters;
  final Map<String, String>? headers;
  final dynamic body;
  final dynamic response;
  final List<RestEndpoint> children;
  bool isExpanded;

  RestEndpoint({
    required this.name,
    required this.isGroup,
    this.method = '',
    this.path = '',
    this.parameters,
    this.headers,
    this.body,
    this.response,
    this.children = const [],
    this.isExpanded = false,
  });
}
