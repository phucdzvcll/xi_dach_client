import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/di.dart';
import 'package:xi_zack_client/features/lobby/presentation/screen/lobby_screen.dart';
import 'package:xi_zack_client/features/room/view/screen/room_screen.dart';
import 'package:xi_zack_client/features/sign_in/presentation/screen/sign_in_screen.dart';

final GetIt injector = GetIt.instance;

void main() async {
  await init(injector);
  EasyLoading.instance.maskColor = Colors.grey;
  EquatableConfig.stringify = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(920, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            onGenerateRoute: (setting) {
              return MaterialPageRoute(builder: (context) {
                switch (setting.name) {
                  case "/":
                    return SignInScreen();
                  case LobbyScreen.routePath:
                    return const LobbyScreen();
                  case RoomScreen.routePath:
                    final RoomArgument args = setting.arguments as RoomArgument;
                    return RoomScreen(
                      roomId: args.roomId,
                      roomName: args.roomName,
                    );
                  default:
                    return SignInScreen();
                }
              });
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: "/",
            builder: EasyLoading.init(),
          );
        });
  }
}
