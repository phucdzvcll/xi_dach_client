part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class LoggingEvent extends SignInEvent {
  final String userName;
  final String password;

  const LoggingEvent({
    required this.userName,
    required this.password,
  });

  @override
  List<Object?> get props => [
        userName,
        password,
      ];
}
