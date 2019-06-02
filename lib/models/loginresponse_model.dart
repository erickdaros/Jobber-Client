import 'package:jobber/models/user_model.dart';

class LoginResponse {
  final User user;
  final String accessToken;

  LoginResponse({this.user, this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: new User.fromJson(json['user']),
      accessToken: json['accessToken'],
    );
  }
}