import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/lobby/data/response/room_response.dart';
import 'package:xi_zack_client/features/lobby/domain/entities/room.dart';
import 'package:xi_zack_client/features/lobby/domain/repositories/lobby_repository.dart';

import '../../domain/mapper/room_mapper.dart';

class LobbyRepositoryImpl extends LobbyRepository {
  final RoomMapper roomMapper;

  LobbyRepositoryImpl({
    required this.roomMapper,
  });

  @override
  Either<Failure, List<Room>> joinToLobbySuccess(List<dynamic> data) {
    try {
      List<RoomResponse> roomResponse =
          data.map((e) => RoomResponse.romJson(e)).toList();
      final List<Room> rooms = roomMapper.mapList(roomResponse);
      return SuccessValue(rooms);
    } catch (e) {
      return FailValue(UnCatchError(exception: FormatException(e.toString())));
    }
  }
}
