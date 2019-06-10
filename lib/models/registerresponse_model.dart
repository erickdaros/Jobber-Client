import 'package:jobber/models/user_model.dart';

class RegisterResponse {
  bool success = false;
  String message = "";
  final User user;
  final String accessToken;

  RegisterResponse({this.user, this.accessToken});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: new User.fromJson(json['user']),
      accessToken: json['accessToken'],
    );
  }
}