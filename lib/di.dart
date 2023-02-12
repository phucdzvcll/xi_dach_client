import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/common/base/interceptor/network.dart';
import 'package:xi_zack_client/common/user_cache.dart';
import 'package:xi_zack_client/features/lobby/di.dart';
import 'package:xi_zack_client/features/room/di.dart';
import 'package:xi_zack_client/features/sign_in/di.dart';

Future<void> init(GetIt injector) async {
  injector.registerLazySingleton<Dio>(() => Dio(baseOptions)..interceptors);

  injector.registerLazySingleton<UserCache>(() => UserCache());

  signInInjector(injector);
  lobbyInjector(injector);
  roomDi(injector);
}
