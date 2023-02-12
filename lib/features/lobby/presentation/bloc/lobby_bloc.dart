import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/common/user_cache.dart';
import 'package:xi_zack_client/features/lobby/domain/entities/room.dart';
import 'package:xi_zack_client/features/lobby/domain/use_case/join_to_lobby_success_use_case.dart';

part 'lobby_event.dart';

part 'lobby_state.dart';

class _ConnectToEvent extends LobbyEvent {
  final bool isConnectSuccessfully;

  _ConnectToEvent({
    required this.isConnectSuccessfully,
  });
}

class _RenderLobbyEvent extends LobbyEvent {
  final dynamic data;

  _RenderLobbyEvent({
    required this.data,
  });
}

class _LobbyErrorEvent extends LobbyEvent {
  final String errorMss;

  _LobbyErrorEvent({
    required this.errorMss,
  });
}

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final AppSocketIo appSocketIo;
  final JoinToLobbySuccessUseCase joinToLobbySuccessHandler;
  final UserCache userCache;

  @override
  void onChange(Change<LobbyState> change) {
    log(change.toString());
    super.onChange(change);
  }

  LobbyBloc({
    required this.appSocketIo,
    required this.joinToLobbySuccessHandler,
    required this.userCache,
  }) : super(LobbyInitial()) {
    on<InitEvent>(
      (event, emit) async {
        appSocketIo.socket.connect();
        emit(ConnectingToSocket());
        appSocketIo.socket.on(
          "connect",
          (data) {
            add(
              _ConnectToEvent(
                isConnectSuccessfully: true,
              ),
            );
          },
        );
        appSocketIo.socket.on(
          "connect_error",
          (data) {
            add(
              _ConnectToEvent(
                isConnectSuccessfully: false,
              ),
            );
          },
        );

        appSocketIo.socket.on("joinToLobbySuccess", (data) {
          try {
            add(_RenderLobbyEvent(data: data));
          } catch (e) {
            add(_LobbyErrorEvent(errorMss: e.toString()));
          }
        });

        appSocketIo.socket.on("createRoomSuccess", (data) {
          try {
            String roomId = data['roomId'];
            add(JoinToRoom(roomId: roomId));
          } catch (e) {
            add(_LobbyErrorEvent(errorMss: e.toString()));
          }
        });
      },
    );

    on<_LobbyErrorEvent>((event, emit) {
      emit(LobbyErrorState(mess: event.errorMss));
    });

    on<_ConnectToEvent>((event, emit) {
      if (event.isConnectSuccessfully) {
        userCache.socketId = appSocketIo.socket.id;
        emit(ConnectingToSocketSuccess(socketId: appSocketIo.socket.id ?? ""));
        appSocketIo.socket.emit("joinToLobby", {});
      } else {
        emit(ConnectingToSocketFail());
      }
    });

    on<_RenderLobbyEvent>(
      (event, emit) async {
        final List data = event.data;
        final Either<Failure, List<Room>> result =
            await joinToLobbySuccessHandler
                .execute(JoinToLobbySuccessParam(data: data));
        if (result.isSuccess) {
          emit(RenderLobbyState(rooms: result.success));
        } else {
          emit(
            LobbyErrorState(
                mess:
                    ((result.fail as UnCatchError).exception as FormatException)
                        .message),
          );
        }
      },
    );

    on<CreateRoomEvent>((event, emit) {
      emit(CreatingRoomState());
      appSocketIo.socket.emit("createRoom", {
        "roomName": event.roomName,
        "playerId": userCache.id,
      });
    });

    on<JoinToRoom>((event, emit) {
      appSocketIo.socket.emit("joinRoom", {
        "roomId": event.roomId,
        "socketId": userCache.socketId,
        "playerId": userCache.id,
      });
    });
  }
}
