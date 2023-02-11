import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String roomId;
  final String roomName;
  final int dateTime;

  const Room({
    required this.roomId,
    required this.roomName,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['roomId'] = roomId;
    map['roomName'] = roomName;
    map['dateTime'] = dateTime;
    return map;
  }

  @override
  List<Object?> get props => [
        roomId,
        roomName,
        dateTime,
      ];
}
