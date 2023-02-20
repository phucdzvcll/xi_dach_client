import 'package:flutter/material.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

class GuessWidget extends StatelessWidget {
  const GuessWidget({
    Key? key,
    required this.guess,
  }) : super(key: key);
  final RoomPlayer guess;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.person),
        Text(guess.playerId),
        Text(guess.isReady.toString()),
      ],
    );
  }
}
