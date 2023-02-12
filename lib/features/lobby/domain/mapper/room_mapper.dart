import 'package:xi_zack_client/common/mapper.dart';
import 'package:xi_zack_client/features/lobby/data/response/room_response.dart';
import 'package:xi_zack_client/features/lobby/domain/entities/room.dart';

class RoomMapper extends Mapper<RoomResponse, Room> {
  @override
  Room map(RoomResponse? input) {
    return Room(
      dateTime: input?.dateTime ?? DateTime.now().microsecondsSinceEpoch,
      roomId: input?.roomId ?? "",
      roomName: input?.roomName ?? "",
      player: (input?.players ?? [])
          .map(
            (e) => RoomPlayerLobby(
                socketId: e.socketId ?? "", playerId: e.playerId ?? ""),
          )
          .toList(),
    );
  }
}
