import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/views/jobdetail_view.dart';
import 'package:jobber/widgets/easing_animation.dart';
import 'package:jobber/widgets/job_card.dart';

class JobFragment extends StatefulWidget {

  static String routeName = 'mainView';
  static String title = 'Jobs';

  List<Proposal> litems = [Proposal("Projeto A","Projeto A com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Proposal("Projeto B","Projeto B com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["NodeJS",]),
    Proposal("Projeto C","Projeto C com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Proposal("Projeto D","Projeto D com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Proposal("Projeto E","Projeto E com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Proposal("Projeto F","Projeto F com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
    Proposal("Projeto com nome realmente muito muito muito mutissimo muitamente longo","Projeto G com intuito de fazer tal coisa. A ideia é isso e tal gostariamos de fazer entre os dias 03 e 22. O objetivo principal desse projeto e conseguir realizar seu objetivo, atraves de ferramentas que auxiliem para que o objetivo seja atngido","",["PHP","Python"]),
  ];

  final bool showAnimation;

  JobFragment({Key key, this.showAnimation = false}) : super(key: key);

  @override
  _JobFragmentState createState() => _JobFragmentState();
}

class _JobFragmentState extends State<JobFragment> {

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

  Widget build_ListView(BuildContext context){
    return RefreshIndicator(
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
                            proposal: widget.litems[index],
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