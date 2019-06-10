import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jobber/utils/sysui_utils.dart';

class JobberTheme{

  const JobberTheme();

  static const MaterialColor mPurple = const MaterialColor(
    0xFF7716A0,
    const <int, Color>{
      50:  const Color(0xFFEFE3F4),
      100: const Color(0xFFD6B9E3),
      200: const Color(0xFFBB8BD0),
      300: const Color(0xFFA05CBD),
      400: const Color(0xFF8B39AE),
      500: const Color(0xFF7716A0),
      600: const Color(0xFF6F1398),
      700: const Color(0xFF64108E),
      800: const Color(0xFF5A0C84),
      900: const Color(0xFF470673),
    },
  );

  static const a400Purple = const Color(0xFFA63CFF);
  static const a700Purple = const Color(0xFF9B23FF);

  static Color purple = const Color(0xFF7716a0);

  static Color purple2 = const Color(0xFF7B05AF);//

  static Color purpleHight = const Color(0xFF7d05cf);
  static Color purpleLow = const Color(0xFFec6ff7);

  static Color accentColor = const Color(0xFF7B05AF);//Color(0xFF9D43DA);
  static Color primaryColor = const Color(0xFF7d05cf);
  static Color accentColorHalf = const Color(0xFF7d05cf).withOpacity(0.75);

  static Color white = const Color(0xFFFAFAFA);



  static Color lightGreen = const Color(0xFF7dc4a2);

  static Color whiteStatusBar = const Color(0xFFe0e0e0);
  static Color whiteAppBar = const Color(0xFFF5F5F5);

  static Color defaultTransparentStatusBar = const Color(0x1A000000);
  static Color defaultTransparentStatusBar2 = const Color(0x40000000);

//  static const Color loginGradientStart = const Color(0xFFfbab66);
//  static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const Color loginGradientStart = const Color(0xFFd500ff);
  static const Color loginGradientEnd = const Color(0xFF3f0979);

  static Color shimmerBaseColor(context){
    return isDarkModeEnabledByContext(context)?Colors.grey[700]:Colors.grey[300];
  }

  static Color shimmerHighlightColor(context){
    return isDarkModeEnabledByContext(context)?Colors.grey[600]:Colors.grey[200];
  }

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData buildTheme(Brightness brightness) {
    return brightness == Brightness.dark
    //Tema Dark
        ?
    ThemeData.dark()
        .copyWith(
      primaryTextTheme: TextTheme(body1: TextStyle(color: Colors.white)),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        fontFamily: 'Montserrat',
      ).copyWith(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white)
      ),
      backgroundColor: Colors.black,
      primaryColor: const Color(0xFF303030),
      accentColor: Colors.grey.shade50,
      textSelectionColor: JobberTheme.purple,
      textSelectionHandleColor: JobberTheme.purple,
      cursorColor: JobberTheme.purple,
    )

    //Tema light
        :
    ThemeData
      (

      primaryTextTheme: TextTheme(
        title: TextStyle(color: Colors.black),
        body1: TextStyle(color: Colors.white),
        body2: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black),
        display1: TextStyle(color: Colors.black),
        display2: TextStyle(color: Colors.black),
        display3: TextStyle(color: Colors.black),
        display4: TextStyle(color: Colors.black),
        overline: TextStyle(color: Colors.black),
        subhead: TextStyle(color: Colors.black),
        subtitle: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.black),
      ),
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
        body2: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black),
        display1: TextStyle(color: Colors.black),
        display2: TextStyle(color: Colors.black),
        display3: TextStyle(color: Colors.black),
        display4: TextStyle(color: Colors.black),
        overline: TextStyle(color: Colors.black),
        subhead: TextStyle(color: Colors.black),
        subtitle: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.black),
      ),
      buttonColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
      buttonTheme: ButtonThemeData(buttonColor: Colors.black),brightness: Brightness.light,
//        ThemeData.light().textTheme.apply(
//      bodyColor: Colors.black,
//      displayColor: Colors.black,
//      fontFamily: 'Montserrat',
//    ).copyWith(
//        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black,),
//        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black,),
//        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black,),
//        body2: TextStyle(color: Colors.black,)
//    ),
      backgroundColor: Colors.white,
      primaryColor: Colors.grey.shade50,
      accentColor: Colors.grey.shade50,
      textSelectionColor: JobberTheme.purple,
      textSelectionHandleColor: JobberTheme.purple,
      cursorColor: JobberTheme.purple,
    );
  }
}

