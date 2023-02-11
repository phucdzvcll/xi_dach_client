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
