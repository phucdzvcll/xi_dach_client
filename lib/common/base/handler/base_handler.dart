import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';

abstract class BaseHandler<I extends dynamic, O> {
  Future<Either<Failure, O>> execute(I data);
}
