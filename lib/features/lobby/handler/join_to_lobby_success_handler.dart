import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/handler/base_handler.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/lobby/handler/mapper/room_mapper.dart';
import 'package:xi_zack_client/features/lobby/handler/models/Room.dart';
import 'package:xi_zack_client/features/lobby/handler/response/room_response.dart';

class JoinToLobbySuccessHandler extends BaseHandler<dynamic, List<Room>> {
  final RoomMapper roomMapper;

  JoinToLobbySuccessHandler({
    required this.roomMapper,
  });

  @override
  Future<Either<Failure, List<Room>>> execute(dynamic data) async {
    try {
      final List<Room> rooms = roomMapper
          .mapList((data as List).map((e) => RoomResponse.romJson(e)).toList());
      return SuccessValue(rooms);
    } catch (e) {
      return FailValue(UnCatchError(exception: FormatException(e.toString())));
    }
  }
}
