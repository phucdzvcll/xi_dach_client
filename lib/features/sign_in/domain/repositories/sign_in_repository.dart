import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/sign_in/domain/entities/user.dart';

abstract class SignInRepository {
  Future<Either<Failure, User>> signIn({
    required String userName,
    required String password,
  });
}
