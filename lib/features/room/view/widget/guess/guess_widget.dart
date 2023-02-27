import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:xi_zack_client/common/utils.dart';
import 'package:xi_zack_client/features/room/bloc/room_bloc.dart';
import 'package:xi_zack_client/features/room/bloc/room_state.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

class GuessWidget extends StatelessWidget {
  const GuessWidget({
    Key? key,
    required this.guess,
  }) : super(key: key);
  final Player guess;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.person),
        Text(guess.playerId),
        Text(guess.pet.toString()),
        Text(guess.isReady.toString()),
        Visibility(
          visible: guess.cards.isNotEmpty,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: _renderCard(),
            ),
          ),
        ),
        BlocBuilder<RoomBloc, RoomState>(
          buildWhen: (previous, current) => current is RenderCheckButtonState,
          builder: (context, state) {
            return Visibility(
              visible: (state is RenderCheckButtonState) && state.enable,
              child: TapDebouncer(
                cooldown: const Duration(seconds: 9999),
                onTap: () async {},
                builder: (ctx, onTap) {
                  return ElevatedButton(
                    onPressed: onTap,
                    child: const Text("Check"),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }

  List<Widget> _renderCard() {
    final List<Positioned> widgets = [];
    for (var i = 0; i < guess.cards.length; i++) {
      double left = i.toDouble() * 20.0;
      widgets.add(
        Positioned(
          left: i == 0 ? null : left,
          child: AppUtils.renderCard(null, width: 50, height: 100),
        ),
      );
    }
    return widgets;
  }
}
