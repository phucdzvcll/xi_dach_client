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
      userCache.isAdmin = false;
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
            userCache.isAdmin = admin!.playerId == userCache.id;
          }
        }
        socketPlayer.removeWhere((element) => element.isAdmin);
        players.addAll(socketPlayer);
        add(_ReRenderRoomEvent());
      });

      appSocketIo.socket.on("newPlayerJoined", (data) {
        var roomPlayer = RoomPlayer.fromJson(data);
        if (admin == null && roomPlayer.isAdmin) {
          admin = roomPlayer;
          add(_ReRenderRoomEvent());
        } else {
          players.add(roomPlayer);
          add(_ReRenderChildPlayerEvent());
        }
      });

      appSocketIo.socket.on("userLeave", (data) {
        userCache.isAdmin = false;
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

      appSocketIo.socket.on("changeAdmin", (data) {
        add(_ChangeAdminEvent(data: data));
      });

      appSocketIo.socket.on("changeAdminSuccess", (data) {
        userCache.isAdmin = true;
        admin = RoomPlayer(
          socketId: userCache.socketId ?? appSocketIo.socket.id ?? "",
          playerId: userCache.id ?? "",
          isMySelf: true,
          isAdmin: true,
        );
        players.removeWhere((element) => element.playerId == userCache.id);
        add(_ReRenderRoomEvent());
      });
    });

    on<LeaveRoomEvent>((event, emit) {
      appSocketIo.socket.emit("leaveRoom", {
        "roomId": roomId,
        "playerId": userCache.id,
        "isAdmin": userCache.id == admin?.playerId,
      });
      appSocketIo.socket.off("joinRoomSuccess");
      appSocketIo.socket.off("newPlayerJoined");
      appSocketIo.socket.off("userLeave");
      appSocketIo.socket.off("changeAdmin");
      appSocketIo.socket.off("changeAdminSuccess");
      emit(LeaveRoomSuccess());
    });

    on<_ReRenderRoomEvent>((event, emit) {
      emit(RenderAdminState(admin: admin));
      emit(RenderAllChildPlayerState(players: players));
    });

    on<_ReRenderChildPlayerEvent>((event, emit) {
      emit(RenderAllChildPlayerState(players: players));
    });

    on<ChangeAdminEvent>(
      (event, emit) {
        emit(LoadingState());
        if (admin == null) {
          appSocketIo.socket.emit(
              "changeAdmin", {"playerId": userCache.id, "roomId": roomId});
        } else {
          emit(ErrorRoomState(errMess: "The room has admin"));
        }
      },
    );

    on<_ChangeAdminEvent>((event, emit) {
      emit(LoadingState());
      final data = event.data;
      final String? playerId = data["playerId"];

      if (playerId != null && admin == null) {
        try {
          RoomPlayer player =
              players.firstWhere((element) => element.playerId == playerId);
          admin = player;
          players.remove(player);
          add(_ReRenderRoomEvent());
        } catch (e) {
          emit(ErrorRoomState(errMess: e.toString()));
        }
      }
    });
  }
}

class _ReRenderRoomEvent extends RoomEvent {}

class _ReRenderChildPlayerEvent extends RoomEvent {}

class _ChangeAdminEvent extends RoomEvent {
  final dynamic data;

  _ChangeAdminEvent({
    required this.data,
  });
}
