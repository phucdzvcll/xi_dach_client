import 'package:flutter/material.dart';
import 'package:xi_zack_client/common/utils.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    Key? key,
    required this.player,
  }) : super(key: key);
  final Player player;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget>
    with TickerProviderStateMixin {
  late AnimationController cardController;
  List<Widget> cards = [];

  @override
  void initState() {
    cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.person),
        Text(widget.player.playerId),
        Text(widget.player.isReady.toString()),
        Text(widget.player.pet.toString()),
        Visibility(
          visible: widget.player.cards.isNotEmpty,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: _renderCard(),
          ),
        ),
      ],
    );
  }

  List<Widget> _renderCard() {
    final List<Widget> widgets = [];
    for (var i = 0; i < widget.player.cards.length; i++) {
      // double left = i.toDouble() * 20.0;
      widgets.add(
        AnimatedBuilder(
          animation: cardController,
          child: GestureDetector(
            child: AppUtils.renderCard(widget.player.cards[i],
                width: 50, height: 100),
            onTap: () {
              cardController.isCompleted
                  ? cardController.reverse()
                  : cardController.forward();
            },
          ),
          builder: (ctx, child) {
            return Positioned(
              left: (cardController.value < 1.0
                  ? null
                  : 25.0 * i * 2),
              child: child!,
            );
          },
        ),
      );
    }
    return widgets;
  }
}
