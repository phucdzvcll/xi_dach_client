import 'package:bloc/bloc.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/common/user_cache.dart';
import 'package:xi_zack_client/features/room/bloc/room_event.dart';
import 'package:xi_zack_client/features/room/bloc/room_state.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final AppSocketIo appSocketIo;
  final UserCache userCache;

  RoomBloc({
    required this.appSocketIo,
    required this.userCache,
  }) : super(RooInitState()) {
    final List<RoomPlayer> players = [];
    late String roomId;
    RoomPlayer? admin;
    on<InitEvent>((event, emit) {
      roomId = event.roomId;
      appSocketIo.socket.emit("joinRoom", {
        "roomId": event.roomId,
        "socketId": userCache.socketId,
        "playerId": userCache.id,
      });

      appSocketIo.socket.on("joinRoomSuccess", (data) {
        final List<RoomPlayer> socketPlayer =
            (data as List).map((e) => RoomPlayer.fromJson(e)).toList();
        players.clear();
        for (var element in socketPlayer) {
          if (element.playerId == userCache.id) {
            element = element.copyWith(isMySelf: true);
          }
          if (admin == null && element.isAdmin) {
            admin = element;
          }
        }
        socketPlayer.removeWhere((element) => element.isAdmin);
        players.addAll(socketPlayer);
        add(_ReRenderRoomEvent());
      });

      appSocketIo.socket.on("newPlayerJoined", (data) {
        var roomPlayer = RoomPlayer.fromJson(data);
        players.add(roomPlayer);
        if (admin == null && roomPlayer.isAdmin) {
          admin = roomPlayer;
        }
        add(_ReRenderChildPlayerEvent());
      });

      appSocketIo.socket.on("userLeave", (data) {
        var roomPlayer = RoomPlayer.fromJson(data);
        if (roomPlayer.isAdmin) {
          admin = null;
          add(_ReRenderRoomEvent());
        } else {
          players.removeWhere(
              (element) => element.playerId == roomPlayer.playerId);
          add(_ReRenderChildPlayerEvent());
        }
      });
    });

    on<LeaveRoomEvent>((event, emit) {
      appSocketIo.socket.emit("leaveRoom", {
        "roomId": roomId,
        "playerId": userCache.id,
        "isAdmin": userCache.id == admin?.playerId,
      });
      appSocketIo.socket.off('joinRoomSuccess');
      appSocketIo.socket.off('newPlayerJoined');
      appSocketIo.socket.off('userLeave');
      emit(LeaveRoomSuccess());
    });

    on<_ReRenderRoomEvent>((event, emit) {
      emit(RenderAdminState(admin: admin));
      emit(RenderAllChildPlayerState(players: players));
    });

    on<_ReRenderChildPlayerEvent>((event, emit) {
      emit(RenderAllChildPlayerState(players: players));
    });
  }
}

class _ReRenderRoomEvent extends RoomEvent {}

class _ReRenderChildPlayerEvent extends RoomEvent {}
