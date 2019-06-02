import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController{
  static setInt(String key, int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int> getInt(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static setString(String key, String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getString(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static setBool(String key, bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool(key)==null){
      return false;
    }
    return prefs.getBool(key);
  }

  static setDouble(String key, double value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double> getDouble(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static setStringList(String key, List<String> value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static setDateTime(String key, DateTime value) async{
    await setString(key, value.year.toString()+"-"+value.month.toString()+"-"+value.day.toString());
  }

  static getDateTime(String key) async{
    String dateTimeString = await getString(key);
    try{
      return new DateTime(
        int.parse(dateTimeString.split("-")[0]),
        int.parse(dateTimeString.split("-")[1]),
        int.parse(dateTimeString.split("-")[2]),
      );
    }catch(err){
      print("Erro ao converter data string para data DateTime");
      return DateTime.now();
    }
  }
}