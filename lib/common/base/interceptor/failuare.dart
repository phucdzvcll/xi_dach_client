import 'package:xi_zack_client/common/base/interceptor/network.dart';

abstract class Failure {
  const Failure();
}

class CommonError extends Failure {}

class ServerError extends Failure {
  const ServerError({required this.errorCode, required this.msg});

  final int errorCode;
  final NetworkError msg;
}

class UnCatchError extends Failure {
  const UnCatchError({required this.exception});

  final Exception exception;
}

abstract class FeatureFailure extends Failure {}
