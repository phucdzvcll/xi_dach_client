import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:xi_zack_client/features/sign_in/data/entities//user_response.dart';

part 'sign_in_service.g.dart';

@RestApi(baseUrl: "http://35.240.138.79:8989")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("/signIn")
  Future<UserResponse> signIn(@Field("userName") String userName, @Field("password") String password);
}
