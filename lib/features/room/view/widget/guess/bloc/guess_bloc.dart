import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

part 'guess_event.dart';

part 'guess_state.dart';

class GuessBloc extends Bloc<GuessEvent, GuessState> {
  final AppSocketIo appSocketIo;
  final Player roomPlayer;

  GuessBloc({
    required this.appSocketIo,
    required this.roomPlayer,
  }) : super(GuessInitial()) {
    int count = 0;

    on<GuessInitEvent>((event, emit) async {
      while (count <= 999999) {
        await Future.delayed(const Duration(seconds: 1));

        count += 1;
        emit(GuessCount(count: count));
      }
    });
  }
}
