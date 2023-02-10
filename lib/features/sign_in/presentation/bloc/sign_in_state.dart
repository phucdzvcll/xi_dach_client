part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
}

class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

class LoggingState extends SignInState {
  @override
  List<Object?> get props => [];
}

class LoggingSuccess extends SignInState {
  @override
  List<Object?> get props => [];
}

class LoggingFail extends SignInState {
  final String errorMess;

  const LoggingFail({
    required this.errorMess,
  });

  @override
  List<Object?> get props => [];
}
