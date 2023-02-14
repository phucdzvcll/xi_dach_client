import 'package:xi_zack_client/features/room/models/room_player.dart';

abstract class RoomState {}

class RooInitState extends RoomState {}

class RenderAllChildPlayerState extends RoomState {
  final List<RoomPlayer> players;

  RenderAllChildPlayerState({
    required this.players,
  });
}

class RenderAdminState extends RoomState {
  final RoomPlayer? admin;

  RenderAdminState({
    required this.admin,
  });
}

class LeaveRoomSuccess extends RoomState {}
