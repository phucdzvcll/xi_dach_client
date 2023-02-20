import 'package:equatable/equatable.dart';

class RoomPlayer extends Equatable {
  final String socketId;
  final String playerId;
  final bool isMySelf;
  final bool isAdmin;
  final bool isReady;

  @override
  List<Object?> get props => [
        socketId,
        playerId,
        isAdmin,
        isAdmin,
        isReady,
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
      isReady: false,
    );
  }

  const RoomPlayer({
    required this.socketId,
    required this.playerId,
    required this.isMySelf,
    required this.isAdmin,
    this.isReady = false,
  });

  RoomPlayer copyWith({
    String? socketId,
    String? playerId,
    bool? isMySelf,
    bool? isAdmin,
    bool? isReady,
  }) {
    return RoomPlayer(
      socketId: socketId ?? this.socketId,
      playerId: playerId ?? this.playerId,
      isMySelf: isMySelf ?? this.isMySelf,
      isAdmin: isAdmin ?? this.isAdmin,
      isReady: isReady ?? this.isReady,
    );
  }
}
