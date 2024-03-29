import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/models/loginresponse_model.dart';
import 'package:jobber/models/registerresponse_model.dart';
import 'package:jobber/routes/api_routes.dart';
import 'package:jobber/views/login_view.dart';

import 'storage_controller.dart';

class AuthController{

  static Future<bool> isUserAuthenticated() async {
    String accessToken = "";
    bool isUserLoggedIn = await SharedPreferencesController.getBool(StorageKeys.isUserLoggedIn);
    if(isUserLoggedIn){
      accessToken = await SharedPreferencesController.getString(StorageKeys.accessToken);
      if(accessToken!=null){
        if(isTokenValid(accessToken)){
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future logout(context) async{
    await SharedPreferencesController.setString(StorageKeys.accessToken,null);
    await SharedPreferencesController.setBool(StorageKeys.isUserLoggedIn,false);
    Navigator.of(context)
        .pushReplacementNamed(LoginView.routeName);
  }

  static bool isTokenValid(String accessToken){
    //TODO: Verificar se o AT é válido na API.
    return true;
  }

  static Future<LoginResponse> login(String email, String password) async {

    String loginUrl = Routes().api.auth.login;

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    LoginResponse lResponse = await http.post(loginUrl,
      body: body,
    ).then((http.Response response){
      if(response.statusCode==200){
        return LoginResponse.fromJson(json.decode(response.body));
      }else{
        return null;
      }
    });

    return lResponse;
  }

  static Future<RegisterResponse> register(String name, String email, String password, String cellphone) async {

    String loginUrl = Routes().api.auth.register;

    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
      'cellphone': cellphone,
    };

    RegisterResponse rResponse = await http.post(loginUrl,
      body: body,
    ).then((http.Response response){
      if(response.statusCode==200){
        RegisterResponse rResponse = RegisterResponse.fromJson(json.decode(response.body));
        rResponse.success = true;
        return rResponse;
      }else{
        RegisterResponse rResponse = RegisterResponse(user: null,accessToken: null);
        rResponse.success = false;
        rResponse.message = json.decode(response.body)['message'];
        return rResponse;
      }
    });

    return rResponse;
  }

  Future<http.Response> fetchPost() async {
//    var teste = Routes.api.auth.login;
//    var client = new http.Client();
//    var url = "https://www.googleapis.com/books/v1/volumes?q={http}";
//
//    // Await the http get response, then decode the json-formatted responce.
//    var response = await http.get(url);
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }
}