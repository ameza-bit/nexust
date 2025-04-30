import 'package:equatable/equatable.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/enums/request_status.dart';
import 'package:nexust/domain/entities/request_entity.dart';
import 'package:nexust/domain/entities/response_entity.dart';

class RequestState extends Equatable {
  final RequestEntity request;
  final ResponseEntity? response;
  final RequestStatus status;
  final String? errorMessage;

  const RequestState({
    required this.request,
    this.response,
    this.status = RequestStatus.initial,
    this.errorMessage,
  });

  factory RequestState.initial() {
    return RequestState(request: RequestEntity(url: '', method: Method.get));
  }

  RequestState copyWith({
    RequestEntity? request,
    ResponseEntity? response,
    RequestStatus? status,
    String? errorMessage,
  }) {
    return RequestState(
      request: request ?? this.request,
      response: response ?? this.response,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [request, response, status, errorMessage];
}
