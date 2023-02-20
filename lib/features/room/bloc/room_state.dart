import 'package:xi_zack_client/features/room/models/room_player.dart';

abstract class RoomState {}

class RooInitState extends RoomState {}

class RenderAllChildPlayerState extends RoomState {
  final List<RoomPlayer> players;

  RenderAllChildPlayerState({
    required this.players,
  });
}

class LoadingState extends RoomState {}

class RenderAdminState extends RoomState {
  final RoomPlayer? admin;

  RenderAdminState({
    required this.admin,
  });
}

class LeaveRoomSuccess extends RoomState {}

class RenderReadyButtonState extends RoomState {
  final bool isReady;

  RenderReadyButtonState({
    required this.isReady,
  });
}

class ErrorRoomState extends RoomState {
  final String errMess;

  ErrorRoomState({
    required this.errMess,
  });
}
