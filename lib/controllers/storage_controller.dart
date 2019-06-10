import 'dart:convert';

import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/models/loginresponse_model.dart';
import 'package:jobber/models/registerresponse_model.dart';
import 'package:jobber/models/skill_model.dart';
import 'package:jobber/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageKeys{
  static const userId = "userid";
  static const userName = "username";
  static const userEmail = "useremail";
//  static const userBirthDate = "userbirthdate";
  static const userCellphone = "usercellphone";
  static const userSkills = "userskills";
  static const userDescription = "userdescription";
  static const userRating = "userrating";
  static const userFreelancesQuantity = "userfreelancesquantity";

  static const accessToken = "accesstoken";
  static const isUserFirstSetupFinished = "isuserfirstsetupfinished";

  static const isUserLoggedIn = "isuserloggedin";

  static const isFirstTime = "isfirsttime";
}

class StorageController{

  static Future saveLocalUser(User user) async {

    List<String> skillsJSONArray = new List<String>();
    Map<String, List<String>> body = {};

    for(int i =0; i<user.skills.length; i++){
      print(json.encode(user.skills[i]));
      skillsJSONArray.add(
          json.encode(user.skills[i]).toString()
      );
    }
    body["skills"] = skillsJSONArray;
    String skillsJSON = json.encode(body);
    print("Salvo local: "+skillsJSON);

    await SharedPreferencesController.setString(StorageKeys.userId, user.id);
    await SharedPreferencesController.setString(StorageKeys.userName, user.name);
    await SharedPreferencesController.setString(StorageKeys.userEmail, user.email);
//    await SharedPreferencesController.setDateTime(StorageKeys.userBirthDate, user.birthDate);
    await SharedPreferencesController.setString(StorageKeys.userCellphone, user.cellphone);
    await SharedPreferencesController.setString(StorageKeys.userSkills, skillsJSON);
    await SharedPreferencesController.setString(StorageKeys.userDescription, user.description);
    await SharedPreferencesController.setInt(StorageKeys.userRating, user.rating);
    await SharedPreferencesController.setInt(StorageKeys.userFreelancesQuantity, user.freelancesQuantity);


  }

  static Future<User> getLocalUser() async {

    String skillsJson = await SharedPreferencesController.getString(StorageKeys.userSkills);
    List<Skill> skills = new List<Skill>();
    List<dynamic> parsedJson = json.decode(skillsJson)['skills'];

    for(int i=0; i<parsedJson.length; i++){
      skills.add(
          Skill.fromJson(json.decode(parsedJson[i]))
      );
    }

    return new User(
      id: await SharedPreferencesController.getString(StorageKeys.userId),
      name: await SharedPreferencesController.getString(StorageKeys.userName),
      email: await SharedPreferencesController.getString(StorageKeys.userEmail),
//      birthDate: await SharedPreferencesController.getDateTime(StorageKeys.userBirthDate),
      cellphone: await SharedPreferencesController.getString(StorageKeys.userCellphone),
//      skills: await SharedPreferencesController.getString(StorageKeys.userSkills),
      skills: skills,
      description: await SharedPreferencesController.getString(StorageKeys.userDescription),
      rating: await SharedPreferencesController.getInt(StorageKeys.userRating),
      freelancesQuantity: await SharedPreferencesController.getInt(StorageKeys.userFreelancesQuantity),
    );
  }

  static Future saveLocalAccessToken(String aT) async {
    print(aT);
    await SharedPreferencesController.setString(StorageKeys.accessToken, aT);
  }

  static Future<String> getLocalAccessToken() async {
    return await SharedPreferencesController.getString(StorageKeys.accessToken);
  }

  static Future saveLoginResponse(LoginResponse loginResponse) async {
    await saveLocalUser(loginResponse.user);
    await saveLocalAccessToken(loginResponse.accessToken);
  }

  static Future saveRegisterResponse(RegisterResponse registerResponse) async {
    await saveLocalUser(registerResponse.user);
    await saveLocalAccessToken(registerResponse.accessToken);
  }
}