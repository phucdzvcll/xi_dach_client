import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xi_zack_client/common/base/extensions/extensions.dart';
import 'package:xi_zack_client/features/lobby/presentation/screen/lobby_screen.dart';
import 'package:xi_zack_client/features/sign_in/presentation/bloc/sign_in_bloc.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({
    Key? key,
  }) : super(key: key);

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => inject(),
      child: Builder(builder: (context) {
        final bloc = BlocProvider.of<SignInBloc>(context);
        return BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is LoggingState) {
              EasyLoading.show(
                  maskType: EasyLoadingMaskType.black,
                  dismissOnTap: false,
                  status: "Logging.....");
            } else {
              EasyLoading.dismiss();
            }

            if (state is LoggingSuccess) {
              Navigator.pushReplacementNamed(context, LobbyScreen.routePath);
            }
          },
          child: Scaffold(
            body: AlertDialog(
              title: const Text(
                'Login to play',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "User Name",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      String errorMess = "";
                      if (state is LoggingFail) {
                        errorMess = state.errorMess;
                      }
                      return Visibility(
                        visible: errorMess.isNotEmpty,
                        child: Text(
                          errorMess,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    bloc.add(LoggingEvent(
                        userName: _userNameController.text,
                        password: _passwordController.text));
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
