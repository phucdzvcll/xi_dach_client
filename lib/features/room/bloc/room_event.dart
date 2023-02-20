abstract class RoomEvent {}

class InitEvent extends RoomEvent {
  final String roomId;

  InitEvent({
    required this.roomId,
  });
}

class LeaveRoomEvent extends RoomEvent {}

class ChangeAdminEvent extends RoomEvent {}

class StartGameEvent extends RoomEvent {}

class ReadyEvent extends RoomEvent {}

class CancelReadyEvent extends RoomEvent {}
