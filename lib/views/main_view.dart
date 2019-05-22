import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/models/proposal_model.dart';
import 'package:jobber/themes/jobber_theme.dart';

import 'fragments/fragment_handler.dart';
import 'fragments/proposal_fragment.dart';
import 'fragments/settings_fragment.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class MainView extends StatefulWidget {

  static String routeName = 'mainView';

  MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget bodyContent;
  bool showFAB;
  Fragment activeFragment;
  String title;

  bool isGrid = true;

  ScrollController _scrollViewController;
  GlobalKey viewPortKey;

  @override
  void initState() {
    super.initState();
    setStatuBarDefault();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _scrollViewController = new ScrollController();
    viewPortKey = GlobalKey();

    bodyContent = ProposalFragment(
      showAnimation: true,
    );
    title = ProposalFragment.title;
    showFAB = true;
    activeFragment = Fragment.Proposal;
  }

  void setStatuBarDefault() async{
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  void switchToFragment(Fragment fragment){
    switch(fragment){
      case Fragment.Proposal:
        setState(() {
          bodyContent = ProposalFragment();
          title = ProposalFragment.title;
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

  void closeDrawer(){
    if(_scaffoldKey.currentState.isDrawerOpen)
      Navigator.pop(context);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  Future<Null> _refresh() async {}

  void _onGridChange(bool value) {
    setState(() => isGrid = value);
  }


  @override
  Widget build(BuildContext context) {


    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    List<Proposal> litems = [Proposal("Projeto A","Projeto A com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
      Proposal("Projeto B","Projeto B com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["NodeJS",]),
      Proposal("Projeto C","Projeto C com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
      Proposal("Projeto D","Projeto D com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
      Proposal("Projeto E","Projeto E com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
      Proposal("Projeto F","Projeto F com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
      Proposal("Projeto com nome realmente muito muito muito mutissimo muitamente longo","Projeto G com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    ];

    ScrollController _scrollViewController = new ScrollController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
//        backgroundColor: JobberTheme.white,
        elevation: activeFragment==Fragment.Proposal?0:4,
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
                      tileMode: TileMode.clamp
                  )
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:AssetImage("assets/profile.jpg"))),
              ),
              accountName: new Container(
                  child: Text(
                    'Erick Daros Silva',
                    style: TextStyle(color: Colors.white),
                  )),
              accountEmail: new Container(
                  child: Text(
                    'erickdarosilva@gmail.com',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
//          MaterialButton(
//            height: 1,
//            padding: EdgeInsets.all(20.0),
//            onPressed: () => {_onGridChange(!isGrid)},
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                    child: Row(
//                      children: <Widget>[
//                        Icon(Icons.view_column),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 15),
//                          child: Text('Mostrar duas colunas'),
//                        ),
//                      ],
//                    )),
//                Switch(
//                  value: isGrid,
//                  onChanged: _onGridChange,
//                  activeColor: JobberTheme.purple,
//                ),
//              ],
//            ),
//          ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Icon(Icons.description),
                  ),
                  Text('Propostas'),
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
                  Text('Minhas Contribuições'),
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
                    child: Icon(Icons.add_to_photos),
                  ),
                  Text('Minhas Propostas'),
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
              onTap: () {
              },
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
                // Update the state of the app
                // ...
              },
            ),
          ],
        ),
      ),
      body: bodyContent,
      floatingActionButton: showFAB ? FloatingActionButton(
//        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: JobberTheme.accentColorHalf,
      ) : Container(),
    );
  }
}