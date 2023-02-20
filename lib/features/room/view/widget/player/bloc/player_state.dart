part of 'player_bloc.dart';

abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class PlayerCount extends PlayerState {
  final int count;

  PlayerCount({
    required this.count,
  });
}
