import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';
import 'package:xi_zack_client/features/room/view/widget/player/bloc/player_bloc.dart';
class PlayerWidget extends StatelessWidget {
  const PlayerWidget({
    Key? key,
    required this.player,
  }) : super(key: key);
  final RoomPlayer player;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerBloc>(
      create: (context) => PlayerBloc()..add(PlayerInitEvent()),
      child: Builder(builder: (context) {
        return Column(
          children: [
            const Icon(Icons.person),
            Text(player.playerId),
            Text(player.isReady.toString()),
            BlocBuilder<PlayerBloc, PlayerState>(
              buildWhen: (previous, current) => current is PlayerCount,
              builder: (context, state) {
                int count = 0;
                if (state is PlayerCount) {
                  count = state.count;
                }

                return Text(count.toString());
              },
            ),
          ],
        );
      }),
    );
  }
}
