import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/models/skill_model.dart';
import 'package:jobber/models/user_model.dart';
import 'package:jobber/routes/api_routes.dart';

import 'storage_controller.dart';

class ApiController{

  static Future<Job> createJob(Job newJob) async {
    String accessToken = "";
    bool isUserLoggedIn = await SharedPreferencesController.getBool(StorageKeys.isUserLoggedIn);
    if(isUserLoggedIn){
      accessToken = await SharedPreferencesController.getString(StorageKeys.accessToken);
      if(accessToken!=null){
//        if(isTokenValid(accessToken)){
//          return new Job("","","",[""]);
//        }else{
//          return new Job("","","",[""]);
//        }
      }else{
        return new Job("","","",[""]);
      }
    }else{
      return new Job("","","",[""]);
    }
  }

  static Future<List<Skill>> getJobberSkills() async {

    String getJobberSkillsUrl = Routes().api.home + Routes().api.getJobberSkills;
    String accessToken = await SharedPreferencesController.getString(StorageKeys.accessToken);

    print("getJobberSkillsUrl: "+getJobberSkillsUrl);

    Map<String, String> headers = {
      'Authorization': accessToken,
    };

    List<Skill> skills = await http.get(getJobberSkillsUrl,
      headers: headers,
    ).then((http.Response response){
      if(response.statusCode==200){
        List<Skill> skills = new List<Skill>();
        List<dynamic> parsedJson = json.decode(response.body);

        for(int i=0; i<parsedJson.length; i++){
          skills.add(
            Skill.fromJson(parsedJson[i])
          );
        }

        return skills;
      }else{
        print("response: "+response.body);
        return null;
      }
    });

    return skills;
  }

  static Future<User> addUserSkills(List<String> skills) async {

    String addUserSkillsUrl = Routes().api.home + "/api/user/skill/add";

    print("addUserSkillsUrl: "+addUserSkillsUrl);

    String accessToken = await SharedPreferencesController.getString(StorageKeys.accessToken);

    Map<String, String> headers = {
      'Authorization': accessToken,
      'Content-Type' : 'application/json',
    };

    Map<String, List<String>> body = {};
    body["skills"] = skills;
    String bodyStr = json.encode(body);
    print(bodyStr);

    User user = await http.post(addUserSkillsUrl,
      headers: headers,
      body: bodyStr,
    ).then((http.Response response){
      if(response.statusCode==200){

        print("response: "+response.body);

        User user = new User.fromJson(json.decode(response.body));

        return user;
      }else{
        print("response: "+response.body);
        return null;
      }
    });

    return user;
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