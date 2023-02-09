import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'lobby_event.dart';

part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final Socket socket;

  LobbyBloc({
    required this.socket,
  }) : super(LobbyInitial()) {
    on<LobbyEvent>((event, emit) {});
  }
}
