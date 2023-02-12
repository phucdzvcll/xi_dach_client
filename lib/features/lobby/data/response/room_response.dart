class RoomResponse {
  String? roomId;
  String? roomName;
  int? dateTime;
  List<RoomPlayerLobbyResponse>? players;

  RoomResponse({
    this.roomId,
    this.roomName,
    this.dateTime,
    this.players,
  });

  factory RoomResponse.romJson(dynamic json) {
    return RoomResponse(
      roomId: json['roomId'],
      roomName: json['roomName'],
      dateTime: json['dateTime'],
      players: ((json['players'] ?? []) as List)
          .map((e) => RoomPlayerLobbyResponse.romJson(e))
          .toList(),
    );
  }
}

class RoomPlayerLobbyResponse {
  final String? socketId;
  final String? playerId;

  RoomPlayerLobbyResponse({
    this.socketId,
    this.playerId,
  });

  factory RoomPlayerLobbyResponse.romJson(dynamic json) {
    return RoomPlayerLobbyResponse(
      socketId: json['socketId'],
      playerId: json['playerId'],
    );
  }
}
