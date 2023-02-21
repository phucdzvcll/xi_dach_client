import 'package:flutter/material.dart';
import 'package:xi_zack_client/common/utils.dart';
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
      ],
    );
  }

  List<Widget> _renderCard() {
    final List<Positioned> widgets = [];
    for (var i = 0; i < 3; i++) {
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
