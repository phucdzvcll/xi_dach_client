abstract class RoomEvent {}

class InitEvent extends RoomEvent {
  final String roomId;

  InitEvent({
    required this.roomId,
  });
}

class LeaveRoomEvent extends RoomEvent {}

class ChangeAdminEvent extends RoomEvent {}
