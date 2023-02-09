import 'package:flutter/material.dart';
import 'package:xi_zack_client/common/constante.dart';
import 'package:xi_zack_client/gen/assets.gen.dart';

class AppUtils {
  static final List<PokerCard> _listA = [
    PokerCard.spaceA,
    PokerCard.clubA,
    PokerCard.heartA,
    PokerCard.diamondA,
  ];

  static int _getAValue(int cardAmount, int currentValue) {
    if (cardAmount < 4) {
      if (currentValue > 12) {
        return 1;
      } else if (currentValue + 11 > 21) {
        return 10;
      } else {
        return 11;
      }
    } else {
      return 1;
    }
  }

  static int getCardValue({
    required PokerCard cardId,
    required int cardAmount,
    required int currentValue,
  }) {
    switch (cardId) {
      case PokerCard.spaceA:
      case PokerCard.diamondA:
      case PokerCard.heartA:
      case PokerCard.clubA:
        return _getAValue(cardAmount, currentValue);
      case PokerCard.space2:
      case PokerCard.space3:
      case PokerCard.space4:
      case PokerCard.space5:
      case PokerCard.space6:
      case PokerCard.space7:
      case PokerCard.space8:
      case PokerCard.space9:
      case PokerCard.space10:
      case PokerCard.club2:
      case PokerCard.club3:
      case PokerCard.club4:
      case PokerCard.club5:
      case PokerCard.club6:
      case PokerCard.club7:
      case PokerCard.club8:
      case PokerCard.club9:
      case PokerCard.club10:
      case PokerCard.diamond2:
      case PokerCard.diamond3:
      case PokerCard.diamond4:
      case PokerCard.diamond5:
      case PokerCard.diamond6:
      case PokerCard.diamond7:
      case PokerCard.diamond8:
      case PokerCard.diamond9:
      case PokerCard.diamond10:
      case PokerCard.heart2:
      case PokerCard.heart3:
      case PokerCard.heart4:
      case PokerCard.heart5:
      case PokerCard.heart6:
      case PokerCard.heart7:
      case PokerCard.heart8:
      case PokerCard.heart9:
      case PokerCard.heart10:
        var aStr = cardId.name.replaceAll(RegExp(r'[^0-9]'), '');
        return int.parse(aStr);
      case PokerCard.spaceJ:
      case PokerCard.spaceQ:
      case PokerCard.spaceK:
      case PokerCard.clubJ:
      case PokerCard.clubQ:
      case PokerCard.clubK:
      case PokerCard.diamondJ:
      case PokerCard.diamondQ:
      case PokerCard.diamondK:
      case PokerCard.heartJ:
      case PokerCard.heartQ:
      case PokerCard.heartK:
        return 10;
    }
  }

  static bool isXiBang(List<PokerCard> cardIds) {
    if (cardIds.length > 2) {
      return false;
    }
    return _listA.toSet().containsAll(cardIds.toSet());
  }

  static bool isXiDach(List<PokerCard> cardIds) {
    if (cardIds.length > 2) {
      return false;
    }
    return cardIds.fold<int>(
            0,
            (previousValue, element) =>
                previousValue +
                getCardValue(
                    cardId: element,
                    cardAmount: cardIds.length,
                    currentValue: previousValue)) ==
        21;
  }

  static Widget renderCard(
    PokerCard? cardId, {
    double? width,
    double? height,
  }) {
    switch (cardId) {
      case PokerCard.spaceA:
        return Assets.images.playingCardSpadeA.image(
          width: width,
          height: height,
        );
      case PokerCard.space2:
        return Assets.images.playingCardSpade2.image(
          width: width,
          height: height,
        );
      case PokerCard.space3:
        return Assets.images.playingCardSpade3.image(
          width: width,
          height: height,
        );
      case PokerCard.space4:
        return Assets.images.playingCardSpade4.image(
          width: width,
          height: height,
        );
      case PokerCard.space5:
        return Assets.images.playingCardSpade5.image(
          width: width,
          height: height,
        );
      case PokerCard.space6:
        return Assets.images.playingCardSpade6.image(
          width: width,
          height: height,
        );
      case PokerCard.space7:
        return Assets.images.playingCardSpade7.image(
          width: width,
          height: height,
        );
      case PokerCard.space8:
        return Assets.images.playingCardSpade8.image(
          width: width,
          height: height,
        );
      case PokerCard.space9:
        return Assets.images.playingCardSpade9.image(
          width: width,
          height: height,
        );
      case PokerCard.space10:
        return Assets.images.playingCardSpade10.image(
          width: width,
          height: height,
        );
      case PokerCard.spaceJ:
        return Assets.images.playingCardSpadeJ.image(
          width: width,
          height: height,
        );
      case PokerCard.spaceQ:
        return Assets.images.playingCardSpadeQ.image(
          width: width,
          height: height,
        );
      case PokerCard.spaceK:
        return Assets.images.playingCardSpadeK.image(
          width: width,
          height: height,
        );
      case PokerCard.clubA:
        return Assets.images.playingCardClubA.image(
          width: width,
          height: height,
        );
      case PokerCard.club2:
        return Assets.images.playingCardClub2.image(
          width: width,
          height: height,
        );
      case PokerCard.club3:
        return Assets.images.playingCardClub3.image(
          width: width,
          height: height,
        );
      case PokerCard.club4:
        return Assets.images.playingCardClub4.image(
          width: width,
          height: height,
        );
      case PokerCard.club5:
        return Assets.images.playingCardClub5.image(
          width: width,
          height: height,
        );
      case PokerCard.club6:
        return Assets.images.playingCardClub6.image(
          width: width,
          height: height,
        );
      case PokerCard.club7:
        return Assets.images.playingCardClub7.image(
          width: width,
          height: height,
        );
      case PokerCard.club8:
        return Assets.images.playingCardClub8.image(
          width: width,
          height: height,
        );
      case PokerCard.club9:
        return Assets.images.playingCardClub9.image(
          width: width,
          height: height,
        );
      case PokerCard.club10:
        return Assets.images.playingCardClub10.image(
          width: width,
          height: height,
        );
      case PokerCard.clubJ:
        return Assets.images.playingCardClubJ.image(
          width: width,
          height: height,
        );
      case PokerCard.clubQ:
        return Assets.images.playingCardClubQ.image(
          width: width,
          height: height,
        );
      case PokerCard.clubK:
        return Assets.images.playingCardClubK.image(
          width: width,
          height: height,
        );
      case PokerCard.diamondA:
        return Assets.images.playingCardDiamondA.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond2:
        return Assets.images.playingCardDiamond2.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond3:
        return Assets.images.playingCardDiamond3.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond4:
        return Assets.images.playingCardDiamond4.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond5:
        return Assets.images.playingCardDiamond5.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond6:
        return Assets.images.playingCardDiamond6.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond7:
        return Assets.images.playingCardDiamond7.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond8:
        return Assets.images.playingCardDiamond8.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond9:
        return Assets.images.playingCardDiamond9.image(
          width: width,
          height: height,
        );
      case PokerCard.diamond10:
        return Assets.images.playingCardDiamond10.image(
          width: width,
          height: height,
        );
      case PokerCard.diamondJ:
        return Assets.images.playingCardDiamondJ.image(
          width: width,
          height: height,
        );
      case PokerCard.diamondQ:
        return Assets.images.playingCardDiamondQ.image(
          width: width,
          height: height,
        );
      case PokerCard.diamondK:
        return Assets.images.playingCardDiamondK.image(
          width: width,
          height: height,
        );
      case PokerCard.heartA:
        return Assets.images.playingCardHeartA.image(
          width: width,
          height: height,
        );
      case PokerCard.heart2:
        return Assets.images.playingCardHeart2.image(
          width: width,
          height: height,
        );
      case PokerCard.heart3:
        return Assets.images.playingCardHeart3.image(
          width: width,
          height: height,
        );
      case PokerCard.heart4:
        return Assets.images.playingCardHeart4.image(
          width: width,
          height: height,
        );
      case PokerCard.heart5:
        return Assets.images.playingCardHeart5.image(
          width: width,
          height: height,
        );
      case PokerCard.heart6:
        return Assets.images.playingCardHeart6.image(
          width: width,
          height: height,
        );
      case PokerCard.heart7:
        return Assets.images.playingCardHeart7.image(
          width: width,
          height: height,
        );
      case PokerCard.heart8:
        return Assets.images.playingCardHeart8.image(
          width: width,
          height: height,
        );
      case PokerCard.heart9:
        return Assets.images.playingCardHeart9.image(
          width: width,
          height: height,
        );
      case PokerCard.heart10:
        return Assets.images.playingCardHeart10.image(
          width: width,
          height: height,
        );
      case PokerCard.heartJ:
        return Assets.images.playingCardHeartJ.image(
          width: width,
          height: height,
        );
      case PokerCard.heartQ:
        return Assets.images.playingCardHeartQ.image(
          width: width,
          height: height,
        );
      case PokerCard.heartK:
        return Assets.images.playingCardHeartK.image(
          width: width,
          height: height,
        );
      default:
        return Assets.images.cardBack.image(
          width: width,
          height: height,
        );
    }
  }
}
