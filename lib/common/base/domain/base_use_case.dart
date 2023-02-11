import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';

abstract class BaseUseCase<I, O> {
  Future<Either<Failure, O>> executeInternal(I input);

  Future<Either<Failure, O>> execute(I input) async {
    try {
      return await executeInternal(input);
    } on Exception catch (e) {
      return FailValue(
        UnCatchError(exception: e),
      );
    }
  }
}

abstract class Param {}

class EmptyParam extends Param{}
