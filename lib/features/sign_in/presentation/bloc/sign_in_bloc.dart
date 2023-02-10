
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xi_zack_client/common/base/domain/either.dart';
import 'package:xi_zack_client/common/base/interceptor/failuare.dart';
import 'package:xi_zack_client/features/sign_in/domain/entities/user.dart';
import 'package:xi_zack_client/features/sign_in/domain/use_case/sign_in_use_case.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;

  SignInBloc({
    required this.signInUseCase,
  }) : super(SignInInitial()) {
    on<LoggingEvent>((event, emit) async {
      if (event.userName.isEmpty || event.password.isEmpty) {
        emit(const LoggingFail(
            errorMess: "Please input User Name and Pass Word"));
      } else {
        emit(LoggingState());
        final Either<Failure, User> res = await signInUseCase.execute(
            SignInParam(userName: event.userName, password: event.password));
        if (res.isSuccess) {
          emit(LoggingSuccess());
        } else {
          if (res.fail is ServerError) {
            emit(const LoggingFail(errorMess: "Sign In Fail"));
          } else {
            emit(const LoggingFail(errorMess: "unknown error"));
          }
        }
      }
    });
  }
}
