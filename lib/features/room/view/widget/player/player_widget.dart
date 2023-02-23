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

class _PlayerWidgetState extends State<PlayerWidget> {
  bool isOverview = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidths = widget.player.cards.length * 40;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.person),
        Text(widget.player.playerId),
        Text(widget.player.isReady.toString()),
        Text(widget.player.pet.toString()),
        Visibility(
          visible: widget.player.cards.isNotEmpty,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                isOverview = !isOverview;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color: Colors.red,
              width: isOverview
                  ? cardWidths
                  : widget.player.cards.length * 20 + 30 ,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 500),
                alignment: isOverview ? Alignment.centerLeft : Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _renderCard(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _renderCard() {
    final List<Widget> widgets = [];
    var cards = widget.player.cards;
    for (var i = 0; i < cards.length; i++) {
      double? left = i == 0
          ? null
          : isOverview
              ? i.toDouble() * 40
              : i.toDouble() * 20.0;
      widgets.add(
        AnimatedPositioned(
          left: left,
          duration: const Duration(milliseconds: 250),
          child: AppUtils.renderCard(cards[i], width: 50, height: 100),
        ),
      );
    }
    return widgets;
  }
}
