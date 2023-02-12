import 'package:equatable/equatable.dart';

class RoomPlayer extends Equatable {
  final String socketId;
  final String playerId;
  final bool isMySelf;
  final bool isAdmin;

  @override
  List<Object?> get props => [
        socketId,
        playerId,
        isAdmin,
        isAdmin,
      ];

  factory RoomPlayer.fromJson(
    Map<String, dynamic> json, {
    bool isMySelf = false,
  }) {
    return RoomPlayer(
      playerId: json['playerId'] ?? "",
      socketId: json["socketId"] ?? "",
      isMySelf: isMySelf,
      isAdmin: json["isAdmin"] ?? false,
    );
  }

  const RoomPlayer({
    required this.socketId,
    required this.playerId,
    required this.isMySelf,
    required this.isAdmin,
  });

  RoomPlayer copyWith({
    String? socketId,
    String? playerId,
    bool? isMySelf,
    bool? isAdmin,
  }) {
    return RoomPlayer(
      socketId: socketId ?? this.socketId,
      playerId: playerId ?? this.playerId,
      isMySelf: isMySelf ?? this.isMySelf,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
