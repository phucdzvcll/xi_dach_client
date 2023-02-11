part of 'lobby_bloc.dart';

abstract class LobbyEvent {}

class InitEvent extends LobbyEvent {}

class CreateRoomEvent extends LobbyEvent {
  final String roomName;

  CreateRoomEvent({
    required this.roomName,
  });
}
