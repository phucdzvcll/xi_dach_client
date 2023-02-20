part of 'guess_bloc.dart';

@immutable
abstract class GuessState {}

class GuessInitial extends GuessState {}

class GuessCount extends GuessState {
  final int count;

  GuessCount({
    required this.count,
  });
}
