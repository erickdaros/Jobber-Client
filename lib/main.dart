import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/views/proposaldetail_view.dart';
import 'package:jobber/views/login_view.dart';
import 'package:jobber/views/main_view.dart';
import 'package:jobber/views/splash_view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(Jobber());

class Jobber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => JobberTheme.buildTheme(brightness),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'Jobber',
          theme: theme,
          home: SplashView(),
          routes: {
            SplashView.routeName : (BuildContext context) => new SplashView(),
            LoginView.routeName : (BuildContext context) => new LoginView(),
            MainView.routeName : (BuildContext context) => new MainView(),
            ProposalDetailView.routeName : (BuildContext context) => new ProposalDetailView(),
          },
        );
      }
    );
  }
}
