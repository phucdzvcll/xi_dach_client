import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String roomId;
  final String roomName;
  final int dateTime;
  final List<RoomPlayerLobby> player;

  const Room({
    required this.roomId,
    required this.roomName,
    required this.dateTime,
    required this.player,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['roomId'] = roomId;
    map['roomName'] = roomName;
    map['dateTime'] = dateTime;
    map['playerAmount'] = player;
    return map;
  }

  @override
  List<Object?> get props => [
        roomId,
        roomName,
        dateTime,
        player,
      ];
}

class RoomPlayerLobby {
  final String socketId;
  final String playerId;

  RoomPlayerLobby({
    required this.socketId,
    required this.playerId,
  });
}
