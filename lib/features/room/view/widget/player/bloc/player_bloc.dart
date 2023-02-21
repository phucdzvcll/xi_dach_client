import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:xi_zack_client/common/constante.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/features/room/models/game.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

part 'player_event.dart';

part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AppSocketIo appSocketIo;
  final Player roomPlayer;

  PlayerBloc({
    required this.appSocketIo,
    required this.roomPlayer,
  }) : super(PlayerInitial()) {
    int count = 0;
    String? gameId;
    List<PokerCard> cards = [];
    on<PlayerInitEvent>((event, emit) async {
      while (count <= 999999) {
        await Future.delayed(const Duration(seconds: 1));
        count += 1;
        emit(PlayerCount(count: count));
      }

      appSocketIo.socket.on("newGame", (data) {
        add(_RenderCardEvent(data: data));
      });
    });

    on<_RenderCardEvent>((event, emit) {
      try {
        Game game = Game.fromJson(event.data);

        gameId = game.gameId;

        cards.clear();

        PlayerDetail playerDetail = game.playerDetail
            .firstWhere((element) => element.playerId == roomPlayer.playerId);
        cards.clear();
        cards.addAll(playerDetail.cards);
      } catch (e) {
        //todo
      }
    });
  }
}

class _RenderCardEvent extends PlayerEvent {
  final dynamic data;

  _RenderCardEvent({
    required this.data,
  });
}
