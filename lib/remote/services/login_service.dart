import 'dart:convert';

import 'package:dio/dio.dart';

import '../../common/user_cache.dart';

class AuthenticationService {
  final UserCache userCache;

  AuthenticationService({
    required this.userCache,
  });

  final dio = Dio(BaseOptions(
    connectTimeout: 10000,
    baseUrl: "http://127.0.0.1:8989",
    sendTimeout: 30000,
  ));

  Future<bool> signIn(String userName, String password) async {
    try {
      final response = await dio.post(
        "/signIn",
        data: {
          "userName": userName,
          "password": password,
        },
      );
      final json = jsonDecode(response.data);
      userCache.userName = json["userName"];
      userCache.uuid = json["ID"];
      return true;
    } catch (e) {
      return false;
    }
  }
}
