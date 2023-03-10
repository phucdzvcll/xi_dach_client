import 'package:xi_zack_client/common/mapper.dart';
import 'package:xi_zack_client/features/sign_in/data/entities//user_response.dart';
import 'package:xi_zack_client/features/sign_in/domain/entities/user.dart';

class UserMapper extends Mapper<UserResponse?, User> {
  @override
  User map(UserResponse? input) {
    return User(
      userName: input?.username ?? "",
      id: input?.userId ?? "",
    );
  }
}
