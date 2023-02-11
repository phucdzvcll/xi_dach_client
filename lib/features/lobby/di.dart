import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/features/lobby/handler/join_to_lobby_success_handler.dart';
import 'package:xi_zack_client/features/lobby/handler/mapper/room_mapper.dart';
import 'package:xi_zack_client/features/lobby/presentation/bloc/lobby_bloc.dart';

void lobbyInjector(GetIt injector) {
  injector.registerLazySingleton<AppSocketIo>(() => AppSocketIo());

  injector.registerLazySingleton<RoomMapper>(() => RoomMapper());

  injector.registerLazySingleton<JoinToLobbySuccessHandler>(
      () => JoinToLobbySuccessHandler(roomMapper: injector.get()));

  injector.registerFactory(
    () => LobbyBloc(
      appSocketIo: injector.get(),
      joinToLobbySuccessHandler: injector.get(),
    ),
  );
}
