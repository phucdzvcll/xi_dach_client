import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:xi_zack_client/common/base/interceptor/network.dart';
import 'package:xi_zack_client/common/user_cache.dart';
import 'package:xi_zack_client/features/sign_in/di.dart';
import 'package:xi_zack_client/remote/services/login_service.dart';

Future<void> init(GetIt injector) async {
  final Socket socket = io(
    'http://127.0.0.1:8082/',
    <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true
    },
  );
  socket.connect();

  injector.registerLazySingleton<Dio>(
      () => Dio(baseOptions)..interceptors);

  injector.registerLazySingleton<Socket>(() => socket);

  injector.registerLazySingleton<UserCache>(() => UserCache());
  injector.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService(userCache: injector.get()));

  signInInjector(injector);
}
