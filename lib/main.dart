import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:xi_zack_client/di.dart';
import 'package:xi_zack_client/features/sign_in/sign_in_screen.dart';

final GetIt injector = GetIt.instance;

void main() async {
  await init(injector);
  EasyLoading.instance.maskColor = Colors.grey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(920, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SignInScreen(
              authService: injector.get(),
            ),
            builder: EasyLoading.init(),
          );
        });
  }
}
