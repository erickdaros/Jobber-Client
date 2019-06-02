import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//void SetStatusColor(Color color) async {
//  try {
//    await FlutterStatusbarcolor.setStatusBarColor(color);
//    if (useWhiteForeground(color)) {
//      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
//      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
//    } else {
//      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
//      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
//    }
//  } on PlatformException catch (e) {
//    debugPrint(e.toString());
//  }
//}

//bool isDarkModeEnabled(SharedPreferences _sharedPreferences) {
//  bool isEnabled = false;
//  if (_sharedPreferences != null)
//    isEnabled =
//        UserUtils.getPreferenciaBool(_sharedPreferences, UserUtils.darkMode);
//  return isEnabled;
//}

void showInSnackBar(context, _scaffoldKey, String value) {
  FocusScope.of(context).requestFocus(new FocusNode());
  _scaffoldKey.currentState?.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontFamily: "WorkSansSemiBold"),
    ),
//      backgroundColor: Colors.blue,
    backgroundColor: Colors.grey.shade900,
    duration: Duration(seconds: 3),
  ));
}

bool isDarkModeEnabledByContext(var context) {
  return Theme.of(context).brightness==Brightness.dark;
}

//void showToast(String message,Toast length){
//  Fluttertoast.showToast(
//      msg: message,
//      toastLength: length,
//      gravity: ToastGravity.BOTTOM,
//      timeInSecForIos: length==Toast.LENGTH_SHORT?1:5,
//      backgroundColor: CNBTheme.green,
//      textColor: Colors.white,
//      fontSize: 16.0
//  );
//}

bool isIPhoneX(var context) {
  var mediaQueryData = MediaQuery.of(context);
  if (Platform.isIOS) {
    var size = mediaQueryData.size;
    print(size.height);
    if ((size.height == 812.0 || size.width == 812.0) || (size.height == 896.0 || size.width == 896.0)) {
      print('entrou');
      return true;
    }
  }
  return false;
}