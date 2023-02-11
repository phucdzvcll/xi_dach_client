import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/features/lobby/handler/join_to_lobby_success_handler.dart';
import 'package:xi_zack_client/features/lobby/handler/models/Room.dart';

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
  final JoinToLobbySuccessHandler joinToLobbySuccessHandler;

  @override
  void onChange(Change<LobbyState> change) {
    log(change.toString());
    super.onChange(change);
  }

  LobbyBloc({
    required this.appSocketIo,
    required this.joinToLobbySuccessHandler,
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
      },
    );

    on<_LobbyErrorEvent>((event, emit) {
      emit(LobbyErrorState(mess: event.errorMss));
    });

    on<_ConnectToEvent>((event, emit) {
      if (event.isConnectSuccessfully) {
        emit(ConnectingToSocketSuccess(socketId: appSocketIo.socket.id ?? ""));
        appSocketIo.socket.emit("joinToLobby", {});
      } else {
        emit(ConnectingToSocketFail());
      }
    });

    on<_RenderLobbyEvent>(
      (event, emit) async {
        final Either<Failure, List<Room>> result =
            await joinToLobbySuccessHandler.execute(event.data);
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
      });
    });
  }
}
