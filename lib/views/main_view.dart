import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/controllers/auth_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/models/user_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/views/newjob_view.dart';

import '../main.dart';
import 'fragments/fragment_handler.dart';
import 'fragments/job_fragment.dart';
import 'fragments/settings_fragment.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class MainView extends StatefulWidget {
  static String routeName = 'mainView';

  final User user;

  MainView({Key key, @required this.user}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState(user: user);
}

class _MainViewState extends State<MainView> with RouteAware {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final duration = const Duration(milliseconds: 300);
  static const MethodChannel actionChannel = MethodChannel('method.channel');

  User user;

  _MainViewState({Key key, @required this.user});

  Widget bodyContent;
  bool showFAB;
  Fragment activeFragment;
  String title;

  bool isGrid = true;

  ScrollController _scrollViewController;
  GlobalKey viewPortKey;

  GlobalKey _fabKey = GlobalKey();

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Jobber.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    Jobber.routeObserver.unsubscribe(this);
    _scrollViewController.dispose();
  }

  @override
  didPopNext() {
    // Show back the FAB on transition back ended
    Timer(duration, () {
      setState(() => showFAB = true);
    });
  }

  fetchData() async {
    user = await StorageController.getLocalUser();
  }

  @override
  initState() {
    super.initState();
    setStatuBarDefault();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _scrollViewController = new ScrollController();
    viewPortKey = GlobalKey();

    bodyContent = JobFragment(
      showAnimation: true,
    );
    title = JobFragment.title;
    showFAB = true;
    activeFragment = Fragment.Proposal;
    fetchData();
  }

  void setStatuBarDefault() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  Future<void> _minimize() async{
    try{
      await actionChannel.invokeMethod('minimize');
    } on PlatformException catch(e) {
      print('${e.message}');
    }
  }

  void switchToFragment(Fragment fragment) {
    switch (fragment) {
      case Fragment.Proposal:
        setState(() {
          bodyContent = JobFragment();
          title = JobFragment.title;
          showFAB = true;
          activeFragment = Fragment.Proposal;
        });
        break;
      case Fragment.Settings:
        setState(() {
          bodyContent = SettingsFragment();
          title = SettingsFragment.title;
          showFAB = false;
          activeFragment = Fragment.Settings;
        });
        break;
    }
    closeDrawer();
  }

  void closeDrawer() {
    if (_scaffoldKey.currentState.isDrawerOpen) Navigator.pop(context);
  }

//  Future<Null> _refresh() async {}

//  void _onGridChange(bool value) {
//    setState(() => isGrid = value);
//  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
        elevation: 0,
        backgroundColor: JobberTheme.accentColor,
        key: key,
        onPressed: () => _onFabTap(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      );

  _onFabTap(BuildContext context) {
    // Hide the FAB on transition start
    setState(() => showFAB = false);

    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          NewJobView(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }

  Future<bool> _onWillPop(){
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    _minimize();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    List<Proposal> litems = [
      Proposal(
          "Projeto A",
          "Projeto A com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "",
          ["PHP", "Python"]),
      Proposal(
          "Projeto B",
          "Projeto B com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "", [
        "NodeJS",
      ]),
      Proposal(
          "Projeto C",
          "Projeto C com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "",
          ["PHP", "Python"]),
      Proposal(
          "Projeto D",
          "Projeto D com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "",
          ["PHP", "Python"]),
      Proposal(
          "Projeto E",
          "Projeto E com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "",
          ["PHP", "Python"]),
      Proposal(
          "Projeto F",
          "Projeto F com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "",
          ["PHP", "Python"]),
      Proposal(
          "Projeto com nome realmente muito muito muito mutissimo muitamente longo",
          "Projeto G com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido",
          "",
          ["PHP", "Python"]),
    ];

    ScrollController _scrollViewController = new ScrollController();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(title),
//        backgroundColor: JobberTheme.white,
            elevation: activeFragment == Fragment.Proposal ? 0 : 4,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            JobberTheme.purple,
                            JobberTheme.purple.withOpacity(0.5),
                          ],
                          begin: const FractionalOffset(1.0, 0.0),
                          end: const FractionalOffset(0.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/profile.jpg"))),
                  ),
                  accountName: new Container(
                      child: Text(
                    user.name==null?"":user.name,
                    style: TextStyle(color: Colors.white),
                  )),
                  accountEmail: new Container(
                      child: Text(
                    user.email==null?"":user.email,
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(Icons.work),
                      ),
                      Text('Jobs'),
                    ],
                  ),
                  onTap: () {
                    switchToFragment(Fragment.Proposal);
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(Icons.assessment),
                      ),
                      Text('Meus Freelas'),
                    ],
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(Icons.work),
                      ),
                      Text('Meus Jobs'),
                    ],
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(Icons.notifications),
                      ),
                      Text('Avisos'),
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(Icons.settings),
                      ),
                      Text('Configurações'),
                    ],
                  ),
                  onTap: () {
                    switchToFragment(Fragment.Settings);
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(Icons.exit_to_app),
                      ),
                      Text('Sair'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('Tem certeza que deseja sair?', style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),),
                          actions: <Widget>[
                            new FlatButton(
                              colorBrightness: Brightness.dark,
                              child: new Text("Sim", style: TextStyle(color: JobberTheme.accentColor),),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await AuthController.logout(context);
                              },
                            ),
                            new FlatButton(
                              child: new Text("Não", style: TextStyle(color: JobberTheme.accentColor),),
                              colorBrightness: Brightness.dark,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          body: bodyContent,
          floatingActionButton: Visibility(
            visible: showFAB,
            child: _buildFAB(context, key: _fabKey),
          )),
    );

//      floatingActionButton: showFAB
//          ? FloatingActionButton(
//              onPressed: () => {
//                    Navigator.of(context).push(MaterialPageRoute<void>(
//                        builder: (BuildContext context) {
//                      return RegisterlView();
//                    }))
//                  },
//              tooltip: 'Increment',
//              child: Icon(
//                Icons.add,
//                color: Colors.white,
//              ),
//              backgroundColor: JobberTheme.accentColor,
//            )
//          : Container(),
//    );
  }
}
