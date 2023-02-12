import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/features/room/bloc/room_bloc.dart';

void roomDi(GetIt injector) {
  injector.registerFactory<RoomBloc>(
    () => RoomBloc(
      appSocketIo: injector.get(),
      userCache: injector.get(),
    ),
  );
}
