import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber/views/login_view.dart';
import 'package:jobber/views/main_view.dart';
import 'package:jobber/views/splash_view.dart';

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
      home: SplashView(),
      routes: {
        SplashView.routeName : (BuildContext context) => new SplashView(),
        LoginView.routeName : (BuildContext context) => new LoginView(),
        MainView.routeName : (BuildContext context) => new MainView(),
      },
    );
  }
}
