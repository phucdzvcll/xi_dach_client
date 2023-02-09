import 'package:flutter/material.dart';
import 'package:xi_zack_client/features/lobby/lobby_screen.dart';

import '../../remote/services/login_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);
  final AuthenticationService authService;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String errorMess = "";
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isShowLoading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: const Text(
          'Login to play',
        ),
        content: Stack(
          children: [
            Visibility(
              visible: isShowLoading,
              child: const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Column(
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
                Visibility(
                  visible: errorMess.isNotEmpty,
                  child: Text(
                    errorMess,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                isShowLoading = true;
              });
              widget.authService
                  .signIn(_userNameController.text, _passwordController.text)
                  .then((value) {
                setState(() {
                  isShowLoading = false;
                  if (value) {
                    errorMess = "";
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const LobbyScreen();
                    }));
                  } else {
                    errorMess = "Login Failed";
                  }
                });
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
