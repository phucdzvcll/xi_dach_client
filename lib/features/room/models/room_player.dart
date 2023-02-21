import 'package:equatable/equatable.dart';
import 'package:xi_zack_client/common/constante.dart';

class Player extends Equatable {
  final String socketId;
  final String playerId;
  final bool isMySelf;
  final bool isAdmin;
  final bool isReady;
  final int index;
  final List<PokerCard> cards;
  final int pet;

  @override
  List<Object?> get props => [
        socketId,
        playerId,
        isAdmin,
        isAdmin,
        isReady,
        index,
        cards,
        pet,
      ];

  factory Player.fromJson(
    Map<String, dynamic> json, {
    bool isMySelf = false,
  }) {
    return Player(
      playerId: json['playerId'] ?? "",
      socketId: json["socketId"] ?? "",
      isMySelf: isMySelf,
      isAdmin: json["isAdmin"] ?? false,
      index: json["index"] ?? -1,
      pet: json["pet"] ?? 10,
      isReady: false,
      cards: List<PokerCard>.from([]),
    );
  }

  const Player({
    required this.socketId,
    required this.playerId,
    required this.isMySelf,
    required this.isAdmin,
    required this.index,
    this.isReady = false,
    this.pet = 10,
    required this.cards,
  });

  Player copyWith({
    String? socketId,
    String? playerId,
    bool? isMySelf,
    bool? isAdmin,
    bool? isReady,
    int? index,
    int? pet,
    List<PokerCard>? cards,
  }) {
    return Player(
      socketId: socketId ?? this.socketId,
      playerId: playerId ?? this.playerId,
      isMySelf: isMySelf ?? this.isMySelf,
      isAdmin: isAdmin ?? this.isAdmin,
      isReady: isReady ?? this.isReady,
      index: index ?? this.index,
      cards: cards ?? this.cards,
      pet: pet ?? this.pet,
    );
  }
}
