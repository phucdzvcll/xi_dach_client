import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/features/lobby/data/repositories_impl/lobby_repository_impl.dart';
import 'package:xi_zack_client/features/lobby/domain/mapper/room_mapper.dart';
import 'package:xi_zack_client/features/lobby/domain/repositories/lobby_repository.dart';
import 'package:xi_zack_client/features/lobby/domain/use_case/join_to_lobby_success_use_case.dart';
import 'package:xi_zack_client/features/lobby/presentation/bloc/lobby_bloc.dart';

void lobbyInjector(GetIt injector) {
  injector.registerLazySingleton<AppSocketIo>(() => AppSocketIo());

  injector.registerFactory<RoomMapper>(() => RoomMapper());

  injector.registerFactory<LobbyRepository>(
      () => LobbyRepositoryImpl(roomMapper: injector.get()));

  injector.registerLazySingleton<JoinToLobbySuccessUseCase>(
      () => JoinToLobbySuccessUseCase(lobbyRepository: injector.get()));

  injector.registerFactory(
    () => LobbyBloc(
      appSocketIo: injector.get(),
      joinToLobbySuccessHandler: injector.get(),
      userCache: injector.get(),
    ),
  );
}
