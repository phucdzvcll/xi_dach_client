import 'package:flutter/material.dart';
import 'package:xi_zack_client/common/base/extensions/extensions.dart';
import 'package:xi_zack_client/features/lobby/bloc/lobby_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LobbyBloc>(
        create: (context) => inject(),
        child: SizedBox(),
      ),
    );
  }
}
