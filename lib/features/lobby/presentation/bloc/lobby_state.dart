part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {}

class LobbyInitial extends LobbyState {
  @override
  List<Object?> get props => [];
}

class ConnectingToSocket extends LobbyState {
  @override
  List<Object?> get props => [];
}

class ConnectingToSocketFail extends LobbyState {
  @override
  List<Object?> get props => [];
}

class ConnectingToSocketSuccess extends LobbyState {
  final String socketId;

  ConnectingToSocketSuccess({
    required this.socketId,
  });

  @override
  List<Object?> get props => [socketId];
}

class LobbyErrorState extends LobbyState {
  final String mess;

  LobbyErrorState({
    required this.mess,
  });

  @override
  List<Object?> get props => [mess];
}

class RenderLobbyState extends LobbyState {
  final List<Room> rooms;

  RenderLobbyState({
    required this.rooms,
  });

  @override
  List<Object?> get props => [rooms];
}

class CreatingRoomState extends LobbyState {
  @override
  List<Object?> get props => [];
}
