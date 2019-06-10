import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/views/jobdetail_view.dart';
import 'package:jobber/widgets/easing_animation.dart';
import 'package:jobber/widgets/job_card.dart';

class JobFeedFragment extends StatefulWidget {

  static String routeName = 'mainView';
  static String title = 'Jobs';

  List<Job> litems = [Job("Projeto A","Projeto A com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python","PHP","Python","PHP","Python","PHP","Python"]),
    Job("Projeto B","Projeto B com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["NodeJS",]),
    Job("Projeto C","Projeto C com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Job("Projeto D","Projeto D com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Job("Projeto E","Projeto E com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Job("Projeto F","Projeto F com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Job("Projeto com nome realmente muito muito muito mutissimo muitamente longo","Projeto G com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
  ];

  final bool showAnimation;
  final bool isCached;

  JobFeedFragment({Key key, this.showAnimation = false, this.isCached = false}) : super(key: key);

  @override
  _JobFeedFragmentState createState() => _JobFeedFragmentState(isCached: isCached);
}

class _JobFeedFragmentState extends State<JobFeedFragment> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  bool isCached;

  _JobFeedFragmentState({Key key, this.isCached = false});

  bool isGrid = true;

  ScrollController _scrollViewController;
  GlobalKey viewPortKey;



  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _scrollViewController = new ScrollController();
    viewPortKey = GlobalKey();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  Future<Null> _refresh() async {
    Timer(Duration(milliseconds: 350), () {
      setState(() {
        isCached = false;
      });
    });
  }

  void _onGridChange(bool value) {
    setState(() => isGrid = value);
  }

  Future<String> _fetchNetworkCall() async{
    if(!isCached){
      await Future.delayed(const Duration(seconds: 3), () => "3");
      print("Terminado carregamento");
      await SharedPreferencesController.setBool(StorageKeys.isJobFeedCached, true);
      setState(() {
        isCached = true;
      });
    }
    return "";
  }

  Widget build_ListView(BuildContext context){
    return  new FutureBuilder<String>(
      future: isCached ? null : _fetchNetworkCall(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return ListView.builder(
              itemCount: 3,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: index==0?const EdgeInsets.only(top: 15, bottom: 25):const EdgeInsets.only(bottom: 25),
                  child: Container(
                    child: new GestureDetector(
                      child: new JobCard(
                        isLoading: true,
                        heightPercent: 25,
                        widthModifier: 5,
                        title:  widget.litems[index].title,
                        description:  widget.litems[index].description,
                        skills:  widget.litems[index].skills,
                      ),
                      onTap: () { },
                    ),
                  ),
                );
              });
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                color: JobberTheme.accentColor,
                child: ListView.builder(
                    itemCount: widget.litems.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: index==0?const EdgeInsets.only(top: 15, bottom: 25):const EdgeInsets.only(bottom: 25),
                        child: Container(
                          child: new GestureDetector(
                            child: new JobCard(
                              heightPercent: 25,
                              widthModifier: 5,
                              title:  widget.litems[index].title,
                              description:  widget.litems[index].description,
                              skills:  widget.litems[index].skills,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return JobDetailView(
                                      job: widget.litems[index],
                                    );
                                  }));
//                    showDialog(
//                      barrierDismissible: false,
//                      context: context,
//                      child: new CupertinoAlertDialog(
//                        title: new Column(
//                          children: <Widget>[
//                            new Text("GridView"),
//                            new Icon(
//                              Icons.favorite,
//                              color: Colors.green,
//                            ),
//                          ],
//                        ),
//                        content: new Text("Selected Item $index"),
//                        actions: <Widget>[
//                          new FlatButton(
//                              onPressed: () {
//                                Navigator.of(context).pop();
//                              },
//                              child: new Text("OK"))
//                        ],
//                      ),
//                    );
                            },
                          ),
                        ),
                      );
                    }),
              );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {


    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    ScrollController _scrollViewController = new ScrollController();

    return Container(
      key: viewPortKey,
      child: widget.showAnimation ? EasingAnimation(
        child: build_ListView(context),
      ):build_ListView(context),
    );
  }
}