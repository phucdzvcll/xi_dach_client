import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';

part 'lobby_event.dart';

part 'lobby_state.dart';

class _ConnectToEvent extends LobbyEvent {
  final bool isConnectSuccessfully;

  _ConnectToEvent({
    required this.isConnectSuccessfully,
  });
}

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final AppSocketIo appSocketIo;

  LobbyBloc({
    required this.appSocketIo,
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
      },
    );

    on<_ConnectToEvent>((event, emit) {
      if (event.isConnectSuccessfully) {
        emit(ConnectingToSocketSuccess(socketId: appSocketIo.socket.id ?? ""));
      } else {
        emit(ConnectingToSocketFail());
      }
    });
  }
}
