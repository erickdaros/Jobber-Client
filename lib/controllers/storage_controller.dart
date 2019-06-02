import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/models/loginresponse_model.dart';
import 'package:jobber/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageKeys{
  static const userId = "userid";
  static const userName = "username";
  static const userEmail = "useremail";
  static const userBirthDate = "userbirthdate";
  static const userCellphone = "usercellphone";
  static const userSkills = "userskills";

  static const accessToken = "accesstoken";

  static const isUserLoggedIn = "isuserloggedin";

  static const isFirstTime = "isfirsttime";
}

class StorageController{

  static Future saveLocalUser(User user) async {
    await SharedPreferencesController.setString(StorageKeys.userId, user.id);
    await SharedPreferencesController.setString(StorageKeys.userName, user.name);
    await SharedPreferencesController.setString(StorageKeys.userEmail, user.email);
    await SharedPreferencesController.setDateTime(StorageKeys.userBirthDate, user.birthDate);
    await SharedPreferencesController.setString(StorageKeys.userCellphone, user.cellphone);
    await SharedPreferencesController.setStringList(StorageKeys.userSkills, user.skills);
  }

  static Future<User> getLocalUser() async {
    return new User(
      id: await SharedPreferencesController.getString(StorageKeys.userId),
      name: await SharedPreferencesController.getString(StorageKeys.userName),
      email: await SharedPreferencesController.getString(StorageKeys.userEmail),
      birthDate: await SharedPreferencesController.getDateTime(StorageKeys.userBirthDate),
      cellphone: await SharedPreferencesController.getString(StorageKeys.userCellphone),
      skills: await SharedPreferencesController.getStringList(StorageKeys.userSkills),
    );
  }

  static Future saveLocalAccessToken(String aT) async {
    await SharedPreferencesController.setString(StorageKeys.accessToken, aT);
  }

  static Future<String> getLocalAccessToken() async {
    return await SharedPreferencesController.getString(StorageKeys.accessToken);
  }

  static Future saveLoginResponse(LoginResponse loginResponse) async {
    await saveLocalUser(loginResponse.user);
    await saveLocalAccessToken(loginResponse.accessToken);
  }
}