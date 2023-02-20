import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';
import 'package:xi_zack_client/features/room/view/widget/guess/bloc/guess_bloc.dart';

class GuessWidget extends StatelessWidget {
  const GuessWidget({
    Key? key,
    required this.guess,
  }) : super(key: key);
  final RoomPlayer guess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GuessBloc>(
      create: (context) => GuessBloc()..add(GuessInitEvent()),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              const Icon(Icons.person),
              Text(guess.playerId),
              Text(guess.isReady.toString()),
              BlocBuilder<GuessBloc, GuessState>(
                buildWhen: (previous, current) => current is GuessCount,
                builder: (context, state) {
                  int count = 0;
                  if (state is GuessCount) {
                    count = state.count;
                  }

                  return Text(count.toString());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
