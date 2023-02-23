import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:xi_zack_client/common/constante.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/common/user_cache.dart';
import 'package:xi_zack_client/features/room/bloc/room_event.dart';
import 'package:xi_zack_client/features/room/bloc/room_state.dart';
import 'package:xi_zack_client/features/room/models/game.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';
import 'package:collection/collection.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final AppSocketIo appSocketIo;
  final UserCache userCache;

  RoomBloc({
    required this.appSocketIo,
    required this.userCache,
  }) : super(RooInitState()) {
    ActionButtonState isReady = ActionButtonState.unReady;
    final List<Player> players = [];
    late String roomId;
    Player? admin;
    String? gameId;
    on<InitEvent>((event, emit) {
      void checkPlayerReady() {
        if (userCache.isAdmin) {
          if (players.isEmpty) {
            isReady = ActionButtonState.disable;
          } else {
            final ready =
                players.firstWhereOrNull((element) => !element.isReady) == null;
            isReady =
                ready ? ActionButtonState.canStart : ActionButtonState.unReady;
          }
          add(_RenderReadyStateEvent(isReady: isReady));
        }
      }

      userCache.isAdmin = false;
      userCache.index = null;
      roomId = event.roomId;
      appSocketIo.socket.emit("joinRoom", {
        "roomId": event.roomId,
        "socketId": userCache.socketId,
        "playerId": userCache.id,
      });

      appSocketIo.socket.on("joinRoomSuccess", (data) {
        final List<Player> socketPlayer =
            (data as List).map((e) => Player.fromJson(e)).toList();
        players.clear();

        for (int i = 0; i < socketPlayer.length; i++) {
          if (socketPlayer[i].playerId == userCache.id) {
            socketPlayer[i] = socketPlayer[i].copyWith(isMySelf: true);
            userCache.index = socketPlayer[i].index;
          }
          if (admin == null && socketPlayer[i].isAdmin) {
            admin = socketPlayer[i];
            userCache.isAdmin = admin!.playerId == userCache.id;
            userCache.index = 0;
          }
        }
        socketPlayer.removeWhere((element) => element.isAdmin);
        socketPlayer.sort(
          (a, b) => a.index.compareTo(b.index),
        );
        players.addAll(socketPlayer);
        add(_ReRenderRoomEvent());
        add(_RenderReadyStateEvent(isReady: isReady));
      });

      appSocketIo.socket.on("newPlayerJoined", (data) {
        var roomPlayer = Player.fromJson(data);
        if (admin == null && roomPlayer.isAdmin) {
          admin = roomPlayer;
          add(_ReRenderRoomEvent());
        } else {
          players.add(roomPlayer);
          add(_ReRenderChildPlayerEvent());
        }
        players.sort(
          (a, b) => a.index.compareTo(b.index),
        );
        checkPlayerReady();
      });

      appSocketIo.socket.on("userLeave", (data) {
        var roomPlayer = Player.fromJson(data);
        if (roomPlayer.isAdmin) {
          admin = null;
          add(_ReRenderRoomEvent());
        } else {
          players.removeWhere(
              (element) => element.playerId == roomPlayer.playerId);
          add(_ReRenderChildPlayerEvent());
        }
        checkPlayerReady();
      });

      appSocketIo.socket.on("changeAdmin", (data) {
        add(_ChangeAdminEvent(data: data));
      });
      appSocketIo.socket.on("playerReady", (data) {
        for (int i = 0; i < players.length; i++) {
          if (players[i].playerId == data['playerId']) {
            players[i] = players[i].copyWith(isReady: true);
            if (players[i].isMySelf) {
              isReady = players[i].isReady
                  ? ActionButtonState.ready
                  : ActionButtonState.unReady;
              add(_RenderReadyStateEvent(
                isReady: isReady,
              ));
            }
          }
        }

        checkPlayerReady();

        add(_ReRenderChildPlayerEvent());
      });

      appSocketIo.socket.on("playerCancelReady", (data) {
        for (int i = 0; i < players.length; i++) {
          if (players[i].playerId == data['playerId']) {
            players[i] = players[i].copyWith(isReady: false);
            if (players[i].isMySelf) {
              isReady = players[i].isReady
                  ? ActionButtonState.ready
                  : ActionButtonState.unReady;
              add(_RenderReadyStateEvent(
                isReady: isReady,
              ));
            }
          }
        }
        add(_ReRenderChildPlayerEvent());
        if (userCache.isAdmin) {
          isReady = ActionButtonState.unReady;
          add(_RenderReadyStateEvent(isReady: isReady));
        }
      });

      appSocketIo.socket.on("changeAdminSuccess", (data) {
        userCache.isAdmin = true;
        admin = Player(
          socketId: userCache.socketId ?? appSocketIo.socket.id ?? "",
          playerId: userCache.id ?? "",
          isMySelf: true,
          isAdmin: true,
          index: userCache.index ?? -1,
          cards: List<PokerCard>.from([]),
        );
        players.removeWhere((element) => element.playerId == userCache.id);
        final ready =
            players.firstWhereOrNull((element) => !element.isReady) == null;
        isReady =
            ready ? ActionButtonState.canStart : ActionButtonState.unReady;
        add(_ReRenderRoomEvent());
        add(_RenderReadyStateEvent(isReady: isReady));
      });

      appSocketIo.socket.on("newGame", (data) {
        isReady = ActionButtonState.disable;
        add(_RenderReadyStateEvent(isReady: isReady));
        add(_RenderGameEvent(data: data));
      });

      appSocketIo.socket.on("playerPet", (data) {
        try {
          String playerId = data["playerId"];
          int playerPet = data["pet"];

          for (int i = 0; i < players.length; i++) {
            if (players[i].playerId == playerId) {
              players[i] = players[i].copyWith(pet: playerPet);
              break;
            }
          }

          add(_ReRenderChildPlayerEvent());
        } catch (e) {
          add(_SocketError(errMess: e.toString()));
        }
      });

      appSocketIo.socket.on("SocketError", (data) {
        String errMess = 'Something went wrong!';
        try {
          errMess = data['mess'];
        } catch (e) {
          errMess = e.toString();
        }
        add(_SocketError(errMess: errMess));
      });
    });

    on<LeaveRoomEvent>((event, emit) {
      appSocketIo.socket.emit("leaveRoom", {
        "roomId": roomId,
        "playerId": userCache.id,
        "isAdmin": userCache.id == admin?.playerId,
      });
      _dispose();
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
          Player player =
              players.firstWhere((element) => element.playerId == playerId);
          admin = player;
          players.remove(player);
          add(_ReRenderRoomEvent());
        } catch (e) {
          emit(ErrorRoomState(errMess: e.toString()));
        }
      }
    });

    on<ReadyEvent>((event, emit) {
      appSocketIo.socket.emit("playerReady", {
        "playerId": userCache.id,
        "roomId": roomId,
      });
    });

    on<CancelReadyEvent>((event, emit) {
      appSocketIo.socket.emit("playerCancelReady", {
        "playerId": userCache.id,
        "roomId": roomId,
      });
    });

    on<StartGameEvent>((event, emit) {
      isReady = ActionButtonState.unReady;
      emit(RenderActionButtonState(
        buttonState: isReady,
        isAdmin: userCache.isAdmin,
      ));
      appSocketIo.socket.emit("startNewGame", {
        "roomId": roomId,
      });
    });

    on<_RenderReadyStateEvent>((event, emit) {
      emit(RenderActionButtonState(
        buttonState: players.isNotEmpty ? isReady : ActionButtonState.disable,
        isAdmin: userCache.isAdmin,
      ));
    });

    on<_RenderGameEvent>((event, emit) {
      try {
        Game game = Game.fromJson(event.data);

        gameId = game.gameId;

        for (var playerDetail in game.playerDetail) {
          Player? player = players
              .firstWhereOrNull((p) => p.playerId == playerDetail.playerId);

          if (player != null) {
            player.cards.addAll(playerDetail.cards);
          } else if (admin?.playerId == playerDetail.playerId) {
            admin?.cards.addAll(playerDetail.cards);
          }
        }
        add(_ReRenderRoomEvent());
      } catch (e) {
        log(e.toString());
        emit(ErrorRoomState(errMess: e.toString()));
      }
    });

    on<PetEvent>((event, emit) {
      appSocketIo.socket.emit("playerPet", {
        "roomId": roomId,
        "pet": event.pet,
        "playerId": userCache.id,
      });
    });
  }

  void _dispose() {
    appSocketIo.socket.off("joinRoomSuccess");
    appSocketIo.socket.off("newPlayerJoined");
    appSocketIo.socket.off("userLeave");
    appSocketIo.socket.off("changeAdmin");
    appSocketIo.socket.off("changeAdminSuccess");
    appSocketIo.socket.off("playerReady");
    appSocketIo.socket.off("playerCancelReady");
    appSocketIo.socket.off("newGame");
    appSocketIo.socket.off("playerPet");
    appSocketIo.socket.off("SocketError");
  }
}

class _ReRenderRoomEvent extends RoomEvent {}

class _RenderReadyStateEvent extends RoomEvent {
  final ActionButtonState isReady;

  _RenderReadyStateEvent({
    required this.isReady,
  });
}

class _ReRenderChildPlayerEvent extends RoomEvent {}

class _ChangeAdminEvent extends RoomEvent {
  final dynamic data;

  _ChangeAdminEvent({
    required this.data,
  });
}

class _RenderGameEvent extends RoomEvent {
  final dynamic data;

  _RenderGameEvent({
    required this.data,
  });
}

class _SocketError extends RoomEvent {
  final String errMess;

  _SocketError({
    required this.errMess,
  });
}
