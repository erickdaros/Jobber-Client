import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/controllers/auth_controller.dart';
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/models/user_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/views/login_view.dart';
import 'package:jobber/views/main_view.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SplashView extends StatefulWidget {

  static String routeName = 'splashView';

  SplashView({Key key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState(){
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    Future.delayed(const Duration(seconds: 3),(){
      _fetchSessionAndNavigate();
    });
  }

  _fetchSessionAndNavigate() async{
    await FlutterStatusbarcolor.setNavigationBarColor(Colors.transparent);
    bool isFirstTime = await SharedPreferencesController.getBool(StorageKeys.isFirstTime);
    if(isFirstTime){
      await SharedPreferencesController.setString(StorageKeys.accessToken, null);
      await SharedPreferencesController.setBool(StorageKeys.isUserLoggedIn, false);
      await SharedPreferencesController.setBool(StorageKeys.isFirstTime, false);
    }
    bool isUserAuthenticated =  await AuthController.isUserAuthenticated();
    if(isUserAuthenticated){
      User user = await StorageController.getLocalUser();
//      Navigator.of(context)
//          .pushReplacementNamed(MainView.routeName);
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return MainView(user: user,);
          }
      ));
    }else{
      Navigator.of(context)
          .pushReplacementNamed(LoginView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: JobberTheme.purple2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Jobber',
                style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white,fontFamily: 'Chillout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}