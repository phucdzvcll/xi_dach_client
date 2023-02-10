import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:xi_zack_client/features/sign_in/data/services/sign_in_service.dart';
import 'package:xi_zack_client/features/sign_in/domain/mapper/user_mapper.dart';
import 'package:xi_zack_client/features/sign_in/data/repositories/sign_in_repository_impl.dart';
import 'package:xi_zack_client/features/sign_in/domain/use_case/sign_in_use_case.dart';
import 'package:xi_zack_client/features/sign_in/presentation/bloc/sign_in_bloc.dart';

void signInInjector(GetIt injector) {
  injector.registerFactory(() => UserMapper());

  injector.registerLazySingleton(() => RestClient(injector.get()));

  injector.registerFactory<SignInRepository>(() => SignInRepositoryImpl(
      restClient: injector.get(), userMapper: injector.get()));
  injector
      .registerFactory(() => SignInUseCase(signInRepository: injector.get()));

  injector.registerFactory(() => SignInBloc(signInUseCase: injector.get()));
}
