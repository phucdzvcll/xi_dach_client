import 'package:xi_zack_client/common/base/domain/base_use_case.dart';
import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/domain/entities/room.dart';
import 'package:xi_zack_client/features/domain/repositories/lobby_repository.dart';

class JoinToLobbySuccessUseCase
    extends BaseUseCase<JoinToLobbySuccessParam, List<Room>> {
  final LobbyRepository lobbyRepository;

  JoinToLobbySuccessUseCase({
    required this.lobbyRepository,
  });

  @override
  Future<Either<Failure, List<Room>>> executeInternal(
      JoinToLobbySuccessParam input) async {
    return lobbyRepository.joinToLobbySuccess(input.data);
  }
}

class JoinToLobbySuccessParam extends Param {
  final List<dynamic> data;

  JoinToLobbySuccessParam({
    required this.data,
  });
}
