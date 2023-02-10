import 'dart:developer';

import 'package:dio/dio.dart';

final BaseOptions baseOptions = BaseOptions(
  connectTimeout: 30000,
  receiveTimeout: 30000,
  contentType: 'application/json',
  responseType: ResponseType.json,
);

// InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
//     onResponse: (response, ResponseInterceptorHandler handler) {
//   // if (response.data is String) {
//   //   response.data = jsonDecode(response.data);
//   // }
//   handler.next(response);
// });

Future<NetworkResult<T>> handleNetworkResult<T>(
  Future<T> request,
) async {
  try {
    final dynamic response = await request;
    if (response is T) {
      return NetworkResult<T>(response: response);
    } else {
      throw Exception();
    }
  } on DioError catch (e) {
    NetworkResult<T> networkResult =
        NetworkResult<T>(error: NetworkError.UNKNOW);

    log(e.error.toString());
    log(e.message.toString());

    switch (e.type) {
      case DioErrorType.connectTimeout:
        networkResult = NetworkResult<T>(error: NetworkError.CONNECT_TIMEOUT);
        break;
      case DioErrorType.sendTimeout:
        networkResult = NetworkResult<T>(error: NetworkError.PROCESS_TIMEOUT);
        break;
      case DioErrorType.receiveTimeout:
        networkResult = NetworkResult<T>(error: NetworkError.PROCESS_TIMEOUT);
        break;
      case DioErrorType.response:
        networkResult = NetworkResult<T>(error: NetworkError.SERVER_ERROR);
        break;
      case DioErrorType.cancel:
        networkResult = NetworkResult<T>(error: NetworkError.CANCEL);
        break;
      case DioErrorType.other:
        networkResult = NetworkResult<T>(error: NetworkError.UNKNOW);
        break;
    }
    return networkResult;
  }
}

enum NetworkError {
  CONNECT_TIMEOUT,
  PROCESS_TIMEOUT,
  SERVER_ERROR,
  CANCEL,
  UNKNOW,
}

class NetworkResult<T> {
  final T? response;
  final NetworkError error;
  final int responseCode;

  NetworkResult({
    this.response,
    this.error = NetworkError.UNKNOW,
    this.responseCode = 200,
  });

  bool isSuccess() {
    return response != null;
  }
}
