class RoomResponse {
  String? roomId;
  String? roomName;
  int? dateTime;

  RoomResponse({
    this.roomId,
    this.roomName,
    this.dateTime,
  });

  factory RoomResponse.romJson(dynamic json) {
    return RoomResponse(
      roomId: json['roomId'],
      roomName: json['roomName'],
      dateTime: json['dateTime'],
    );
  }
}
