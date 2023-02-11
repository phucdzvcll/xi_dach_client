import 'package:xi_zack_client/common/mapper.dart';
import 'package:xi_zack_client/features/lobby/handler/models/Room.dart';
import 'package:xi_zack_client/features/lobby/handler/response/room_response.dart';

class RoomMapper extends Mapper<RoomResponse, Room> {
  @override
  Room map(RoomResponse? input) {
    return Room(
      dateTime: input?.dateTime ?? DateTime.now().microsecondsSinceEpoch,
      roomId: input?.roomId ?? "",
      roomName: input?.roomName ?? "",
    );
  }
}
