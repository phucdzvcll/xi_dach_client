import 'package:xi_zack_client/features/room/models/room_player.dart';

abstract class RoomState {}

class RooInitState extends RoomState {}

class RenderAllChildPlayerState extends RoomState {
  final List<Player> players;

  RenderAllChildPlayerState({
    required this.players,
  });
}

class LoadingState extends RoomState {}

class RenderAdminState extends RoomState {
  final Player? admin;

  RenderAdminState({
    required this.admin,
  });
}

class LeaveRoomSuccess extends RoomState {}

class RenderActionButtonState extends RoomState {
  final ActionButtonState buttonState;
  final bool isAdmin;

  RenderActionButtonState({
    required this.buttonState,
    required this.isAdmin,
  });
}

class ErrorRoomState extends RoomState {
  final String errMess;

  ErrorRoomState({
    required this.errMess,
  });
}

enum ActionButtonState {
  ready,
  unReady,
  canStart,
  disable,
  pull,
  showCard,
  checkCard,
}
