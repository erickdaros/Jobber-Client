import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/views/main_view.dart';

class SplashView extends StatefulWidget {

  static String routeName = 'splashPage';

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
    Navigator.of(context)
        .pushReplacementNamed(MainView.routeName);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Jobber',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}