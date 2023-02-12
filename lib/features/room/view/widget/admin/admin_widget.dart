import 'package:flutter/material.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

class AdminWidget extends StatelessWidget {
  const AdminWidget({
    Key? key,
    required this.admin,
  }) : super(key: key);
  final RoomPlayer admin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.person),
        Text(admin.playerId),
      ],
    );
  }
}
