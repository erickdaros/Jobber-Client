import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsFragment extends StatefulWidget {

  static String routeName = 'settingsView';
  static String title = 'Configurações';

  @override
  State createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool darkTheme = false;
  bool fullScreen = false;
  bool snapDashboard = false;

  void _onThemeChange(bool value) {
    setState(() => darkTheme = value);
    _sharedPreferences.setBool('dark_mode', darkTheme);
    DynamicTheme.of(context)
        .setBrightness(darkTheme ? Brightness.dark : Brightness.light);
  }

  void _onFullScreenChange(bool value) {
    setState(() => fullScreen = value);
//    UserUtils.setBool(_sharedPreferences, UserUtils.isFullScreenModeEnabled, fullScreen);
  }

  void _onSnapChange(bool value) {
    setState(() => snapDashboard = value);
//    UserUtils.setFreeNavigationMode(_sharedPreferences, !snapDashboard);
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;

    setState(() {
      if(_sharedPreferences.getBool('dark_mode')==null) {
        darkTheme = false;
        _sharedPreferences.setBool('dark_mode', false);
      }else{
        darkTheme =
            _sharedPreferences.getBool('dark_mode');
      }
//      snapDashboard = !UserUtils.getPreferenciaBool(
//          _sharedPreferences, UserUtils.freeNavigationMode);
//      fullScreen = UserUtils.getPreferenciaBool(
//          _sharedPreferences, UserUtils.isFullScreenModeEnabled);
    });
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();

    super.initState();
  }

  @override
  void dispose() {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//      statusBarColor: Colors.transparent,
//    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try{
//      darkTheme =
//          UserUtils.getPreferenciaBool(_sharedPreferences, UserUtils.darkMode);
//      snapDashboard = !UserUtils.getPreferenciaBool(
//          _sharedPreferences, UserUtils.freeNavigationMode);
//      fullScreen = UserUtils.getPreferenciaBool(
//          _sharedPreferences, UserUtils.isFullScreenModeEnabled);
    }catch(err){}
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//      statusBarColor: CNBTheme.whiteStatusBar,
//    ));
//    if (_sharedPreferences != null)
//      FlutterStatusbarcolor.setStatusBarWhiteForeground(
//          isDarkModeEnabled(_sharedPreferences));

    return ListView(
      children: <Widget>[
//            _Heading("Aparência")
        MaterialButton(
          height: 1,
//            textColor: const Color(0xFF262626),
          padding: EdgeInsets.all(20.0),
          onPressed: () => {_onThemeChange(!darkTheme)},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.brightness_3),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Modo Noturno"),
                      ),
                    ],
                  )),
              Switch(
                value: darkTheme,
                onChanged: _onThemeChange,
                activeColor: JobberTheme.accentColor,
              ),
            ],
          ),
        ),
//          MaterialButton(
//            height: 1,
////              textColor: const Color(0xFF262626),
//            padding: EdgeInsets.all(20.0),
//            onPressed: () => {_onFullScreenChange(!fullScreen)},
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                    child: Row(
//                      children: <Widget>[
//                        Icon(Icons.zoom_out_map),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 15),
//                          child: Text("Modo FullScreen"),
//                        ),
//                      ],
//                    )),
//                Switch(
//                  value: fullScreen,
//                  onChanged: _onFullScreenChange,
//                  activeColor: JobberTheme.accentColor,
//                ),
//              ],
//            ),
//          ),
//          MaterialButton(
//            height: 1,
////              textColor: const Color(0xFF262626),
//            padding: EdgeInsets.all(20.0),
//            onPressed: () => {_onSnapChange(!snapDashboard)},
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                    child: Row(
//                      children: <Widget>[
//                        Icon(Icons.view_carousel),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 15),
//                          child: Text("Snap no Dashboard"),
//                        ),
//                      ],
//                    )),
//                Switch(
//                  value: snapDashboard,
//                  onChanged: _onSnapChange,
//                  activeColor: JobberTheme.accentColor,
//                ),
//              ],
//            ),
//          ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 48.0,
      padding: const EdgeInsetsDirectional.only(start: 56.0),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: theme.textTheme.body1,
      ),
    );
  }
}

//
//class SwitchableButton extends StatefulWidget {
//
//  final IconData icon;
//  final String title;
//  final String caption;
//  final Function onPressed;
//
//  const SwitchableButton({ Key key,
//    this.icon, this.title, this.caption, this.onPressed,
//  }) : super(key: key);
//  @override
//  State createState() => new SwitchableButtonState();
//}
//
//class SwitchableButtonState extends State<SwitchableButton> {
//
//  bool switchState;
//  void _onSwitchPressed(bool value) => setState(() => switchState = value);
//
//  @override
//  Widget build(BuildContext context) {
////    print(this.onPressed);
//    return MaterialButton(
//      height: 1,
//      textColor: const Color(0xFF000000),
//      padding: EdgeInsets.all(20.0),
//      onPressed: ()=>{_onSwitchPressed(!switchState)},
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Container(
//              child: Row(
//                children: <Widget>[
//                  Icon(widget.icon),
//                  Padding(
//                    padding: const EdgeInsets.only(left: 15),
//                    child: Text(widget.title),
//                  ),
//                ],
//              )
//          ),
//          Switch(
//            value: switchState,
//            onChanged: _onSwitchPressed,
//            activeColor: CNBTheme.green,
//          ),
//        ],
//      ),
//    );
//  }
//}
