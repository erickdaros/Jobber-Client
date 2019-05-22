import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber/pages/login_page.dart';
import 'package:jobber/pages/main_page.dart';
import 'package:jobber/pages/splash_page.dart';

void main() => runApp(Jobber());

class Jobber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: 'Jobber',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashPage(),
      routes: {
        SplashPage.routeName : (BuildContext context) => new SplashPage(),
        LoginPage.routeName : (BuildContext context) => new LoginPage(),
        MainPage.routeName : (BuildContext context) => new MainPage(),
      },
    );
  }
}
