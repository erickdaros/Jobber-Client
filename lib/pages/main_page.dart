import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/models/ask_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/widgets/easing_animation.dart';
import 'package:jobber/widgets/job_card.dart';

class MainPage extends StatefulWidget {

  static String routeName = 'mainPage';

  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  bool isGrid = true;


  ScrollController _scrollViewController;
  GlobalKey viewPortKey;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _scrollViewController = new ScrollController();
    viewPortKey = GlobalKey();
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

    List<Proposal> litems = [Proposal("Projeto A","Projeto A com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["PHP","Python"]),
      Proposal("Projeto B","Projeto B com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["NodeJS",]),
      Proposal("Projeto C","Projeto C com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["PHP","Python"]),
      Proposal("Projeto D","Projeto D com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["PHP","Python"]),
      Proposal("Projeto E","Projeto E com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["PHP","Python"]),
      Proposal("Projeto F","Projeto F com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["PHP","Python"]),
      Proposal("Projeto com nome longo demais","Projeto G com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22","",["PHP","Python"]),
    ];

    ScrollController _scrollViewController = new ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Propostas"),
        backgroundColor: JobberTheme.white,
        elevation: 0,
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
            MaterialButton(
              height: 1,
              padding: EdgeInsets.all(20.0),
              onPressed: () => {_onGridChange(!isGrid)},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.view_column),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text('Mostrar duas colunas'),
                          ),
                        ],
                      )),
                  Switch(
                    value: isGrid,
                    onChanged: _onGridChange,
                    activeColor: JobberTheme.purple,
                  ),
                ],
              ),
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
                // Update the state of the app
                // ...
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
                // Update the state of the app
                // ...
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
      body: Container(
        key: viewPortKey,
        child: EasingAnimation(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            color: JobberTheme.purple,
            child: GridView.builder(
                itemCount: litems.length,
                physics: BouncingScrollPhysics(),
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isGrid?2:1),
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    child: new JobCard(
                      heightPercent: isGrid?22:45,
                      isMini: isGrid,
                      widthModifier: 5,
                      title: litems[index].title,
                      description: litems[index].description,
                      skills: litems[index].skills,
                    ),
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        child: new CupertinoAlertDialog(
                          title: new Column(
                            children: <Widget>[
                              new Text("GridView"),
                              new Icon(
                                Icons.favorite,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          content: new Text("Selected Item $index"),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: new Text("OK"))
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
      ),
//    floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
    );
  }
}