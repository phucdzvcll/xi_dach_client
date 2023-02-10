import 'package:xi_zack_client/common/base/domain/base_use_case.dart';
import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:xi_zack_client/features/sign_in/domain/entities/user.dart';

class SignInUseCase extends BaseUseCase<SignInParam, User> {
  final SignInRepository signInRepository;

  SignInUseCase({
    required this.signInRepository,
  });

  @override
  Future<Either<Failure, User>> executeInternal(SignInParam input) async {
    return signInRepository.signIn(
        userName: input.userName, password: input.password);
  }
}

class SignInParam extends Param {
  final String userName;
  final String password;

  SignInParam({
    required this.userName,
    required this.password,
  });
}
