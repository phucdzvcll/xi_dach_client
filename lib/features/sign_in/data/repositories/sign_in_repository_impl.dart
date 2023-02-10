import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/common/base/interceptor/network.dart';
import 'package:xi_zack_client/features/sign_in/data/models/user_response.dart';
import 'package:xi_zack_client/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:xi_zack_client/features/sign_in/data/services/sign_in_service.dart';
import 'package:xi_zack_client/features/sign_in/domain/entities/user.dart';
import 'package:xi_zack_client/features/sign_in/domain/mapper/user_mapper.dart';

class SignInRepositoryImpl implements SignInRepository {
  final RestClient restClient;
  final UserMapper userMapper;

  SignInRepositoryImpl({
    required this.restClient,
    required this.userMapper,
  });

  @override
  Future<Either<Failure, User>> signIn(
      {required String userName, required String password}) async {
    final request = restClient.signIn(userName, password);
    final NetworkResult<UserResponse> response =
        await handleNetworkResult(request);
    if (response.isSuccess()) {
      return SuccessValue(userMapper.map(response.response));
    } else {
      return FailValue(
        ServerError(errorCode: response.responseCode, msg: response.error),
      );
    }
  }
}
