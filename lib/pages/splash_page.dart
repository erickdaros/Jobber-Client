import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/pages/main_page.dart';

class SplashPage extends StatefulWidget {

  static String routeName = 'splashPage';

  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

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
        .pushReplacementNamed(MainPage.routeName);
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