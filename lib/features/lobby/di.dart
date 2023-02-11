import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/common/socket/app_socket.dart';
import 'package:xi_zack_client/features/lobby/presentation/bloc/lobby_bloc.dart';

void lobbyInjector(GetIt injector) {
  injector.registerLazySingleton<AppSocketIo>(() => AppSocketIo());

  injector.registerFactory(() => LobbyBloc(appSocketIo: injector.get()));
}
