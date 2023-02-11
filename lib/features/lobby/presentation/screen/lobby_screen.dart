import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xi_zack_client/common/base/extensions/extensions.dart';
import 'package:xi_zack_client/features/lobby/presentation/bloc/lobby_bloc.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  static const String routePath = "/lobby";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LobbyBloc>(
      create: (context) => inject()..add(InitEvent()),
      child: Builder(builder: (context) {
        return BlocListener<LobbyBloc, LobbyState>(
          listener: (context, state) {
            if (state is ConnectingToSocket) {
              EasyLoading.show(
                  maskType: EasyLoadingMaskType.black,
                  dismissOnTap: false,
                  status: "Waiting to connect....");
            } else {
              EasyLoading.dismiss();
            }
            if (state is ConnectingToSocketFail) {
              EasyLoading.showError("Connect Fail",
                  duration: const Duration(seconds: 3));
            } else if (state is ConnectingToSocketSuccess) {
              EasyLoading.showSuccess("Connect Success",
                  duration: const Duration(seconds: 3));
            }
          },
          child: Scaffold(),
        );
      }),
    );
  }
}
