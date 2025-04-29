import 'package:nexust/domain/entities/request_entity.dart';
import 'package:nexust/domain/entities/response_entity.dart';

abstract class RequestRepository {
  Future<ResponseEntity> sendRequest(RequestEntity request);
}
