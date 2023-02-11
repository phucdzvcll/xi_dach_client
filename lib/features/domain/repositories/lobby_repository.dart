import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/domain/entities/room.dart';

abstract class LobbyRepository {
  Either<Failure, List<Room>> joinToLobbySuccess(List<dynamic> data);
}
