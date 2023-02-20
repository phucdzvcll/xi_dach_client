import 'dart:async';

import 'package:bloc/bloc.dart';

part 'player_event.dart';

part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial()) {
    int count = 0;

    on<PlayerInitEvent>((event, emit) async {
      while (count <= 999999) {
        await Future.delayed(const Duration(seconds: 1));

        count += 1;
        emit(PlayerCount(count: count));
      }
    });
  }
}
