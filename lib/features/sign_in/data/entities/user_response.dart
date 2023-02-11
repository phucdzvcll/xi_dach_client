class UserResponse {
  final String? username;
  final String? userId;

  UserResponse({
    this.username,
    this.userId,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json["ID"],
      username: json["userName"],
    );
  }


}
