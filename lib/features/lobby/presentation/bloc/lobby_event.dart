part of 'lobby_bloc.dart';

abstract class LobbyEvent {}

class InitEvent extends LobbyEvent {}

class CreateRoomEvent extends LobbyEvent {
  final String roomName;

  CreateRoomEvent({
    required this.roomName,
  });
}

class JoinToRoomEvent extends LobbyEvent {
  final String roomId;
  final String roomName;

  JoinToRoomEvent({
    required this.roomId,
    required this.roomName,
  });
}
