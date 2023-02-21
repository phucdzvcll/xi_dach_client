import 'package:equatable/equatable.dart';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:xi_zack_client/common/constante.dart';

class Game extends Equatable {
  final String gameId;
  final String roomId;
  final List<PlayerDetail> playerDetail;

  const Game({
    required this.gameId,
    required this.roomId,
    required this.playerDetail,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameId'] ?? "",
      roomId: json['roomId'] ?? "",
      playerDetail: ((json['playerDetail'] ?? []) as List)
          .map((e) => PlayerDetail.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        gameId,
        roomId,
        playerDetail,
      ];
}

class PlayerDetail extends Equatable {
  final String playerId;
  final String socketId;
  final int index;
  final List<PokerCard> cards;

  const PlayerDetail({
    required this.playerId,
    required this.socketId,
    required this.index,
    required this.cards,
  });

  factory PlayerDetail.fromJson(Map<String, dynamic> json) {
    List<PokerCard?> fromList = EnumToString.fromList<PokerCard?>(
        PokerCard.values, (json["cards"] ?? []));
    return PlayerDetail(
      playerId: json['playerId'] ?? "",
      socketId: json['socketId'] ?? "",
      index: json['index'] ?? -1,
      cards: List<PokerCard>.from(fromList.where((e) => e != null).toList()),
    );
  }

  @override
  List<Object?> get props => [
        playerId,
        socketId,
        index,
        cards,
      ];
}
