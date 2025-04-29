import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/domain/repositories/request_repository.dart';
import 'package:nexust/presentation/blocs/request/request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  final RequestRepository _requestRepository;

  RequestCubit(this._requestRepository) : super(RequestState.initial());

  void updateUrl(String url) {
    emit(state.copyWith(request: state.request.copyWith(url: url)));
  }

  void updateMethod(Method method) {
    emit(state.copyWith(request: state.request.copyWith(method: method)));
  }

  void updateQueryParams(Map<String, dynamic> queryParams) {
    emit(
      state.copyWith(request: state.request.copyWith(queryParams: queryParams)),
    );
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
