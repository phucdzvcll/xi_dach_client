import 'package:flutter/material.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({
    Key? key,
    required this.player,
  }) : super(key: key);
  final RoomPlayer player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.person),
        Text(player.playerId),
      ],
    );
  }
}
