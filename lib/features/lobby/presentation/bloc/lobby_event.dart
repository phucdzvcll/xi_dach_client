part of 'lobby_bloc.dart';

abstract class LobbyEvent {}

class InitEvent extends LobbyEvent {}

class CreateRoomEvent extends LobbyEvent {
  final String roomName;

  CreateRoomEvent({
    required this.roomName,
  });
}

class JoinToRoom extends LobbyEvent {
  final String roomId;

  JoinToRoom({
    required this.roomId,
  });
}
