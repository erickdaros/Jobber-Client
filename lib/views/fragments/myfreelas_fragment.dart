import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/widgets/job_card.dart';
import 'package:shimmer/shimmer.dart';

import '../jobdetail_view.dart';

class MyFreelasFragment extends StatefulWidget {

  static String routeName = 'myfreelasView';
  static String title = 'Meus Freelas';

  final TabController tabController;

  static Widget buildTabBar(TabController tabController, context){
    return TabBar(
      isScrollable: true,
      controller: tabController,
      indicatorColor: JobberTheme.accentColor,
      labelColor: JobberTheme.accentColor,
      unselectedLabelColor: Theme.of(context).textTheme.body1.color,
      tabs: [
        Tab(icon: Text("Em Andamento")),
        Tab(icon: Text("Finalizados")),
      ],
    );
  }

  final bool isCached;
  MyFreelasFragment({Key key, this.tabController, this.isCached = false}) : super(key: key);

  @override
  State createState() => _MyFreelasFragmentState();
}

class _MyFreelasFragmentState extends State<MyFreelasFragment> {

  bool isCached;

  _MyFreelasFragmentState({Key key, this.isCached = false});

  @override
  void initState() {
    emAndamentoJobs.clear();
    finalizadoJobs.clear();
    emAndamentoJobs.add(Job("Job1", "", "", []));
    emAndamentoJobs.add(Job("Job2", "", "", []));
    emAndamentoJobs.add(Job("Job3", "", "", []));
    emAndamentoJobs.add(Job("Job4", "", "", []));
    emAndamentoJobs.add(Job("Job4", "", "", []));
    emAndamentoJobs.add(Job("Job4", "", "", []));
    emAndamentoJobs.add(Job("Job4", "", "", []));
    emAndamentoJobs.add(Job("Job4", "", "", []));
    finalizadoJobs.add(Job("Job5", "", "", []));
    finalizadoJobs.add(Job("Job6", "", "", []));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _fetchNetworkCall() async{
    if(!isCached){
      await Future.delayed(const Duration(seconds: 3), () => "3");
      print("Terminado carregamento");
      await SharedPreferencesController.setBool(StorageKeys.isMyFreelasCached, true);
      setState(() {
        isCached = true;
      });
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: <Widget>[
        new FutureBuilder<String>(
      future: isCached ? null : _fetchNetworkCall(), // async work
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new StatefulListView(isLoading: true,isCached: isCached,);
          default:
            if (snapshot.hasError)
              return new Text('Erro: ${snapshot.error}');
            else
              return new StatefulListView(jobs: emAndamentoJobs,isLoading: false,);
        }
      },
    ),
        new FutureBuilder<String>(
          future: _fetchNetworkCall(), // async work
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new StatefulListView(isLoading: true,);
              default:
                if (snapshot.hasError)
                  return new Text('Erro: ${snapshot.error}');
                else
                  return new StatefulListView(jobs: finalizadoJobs,isLoading: false,);
            }
          },
        ),
      ],
    );
  }
}

//List<Widget> tab1 = new List<Widget>();
//List<Widget> tab2 = new List<Widget>();
//
//List<List<Widget>> tabContent = <List<Widget>>[
//  tab1,
//  tab2,
//];

List<Job> emAndamentoJobs = new List<Job>();
List<Job> finalizadoJobs = new List<Job>();

const List<List<Job>> content = const <List<Job>>[
//  const List<Job>[Job("Job1","","",[]),Job("Job2","","",[]),Job("Job3","","",[]),Job("Job4","","",[])],
//  const [Job("Job5","","",[]),Job("Job6","","",[])]
];

class JobList extends StatelessWidget {

  JobList({Key key, this.jobs, this.isCached = false}) : super(key: key);

  final List<Job> jobs;
  bool isCached;

  Widget build_ListView(BuildContext context){
    return ListView.builder(
        itemCount: jobs.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: index==0?const EdgeInsets.only(top: 15, bottom: 25):const EdgeInsets.only(bottom: 25),
            child: Container(
              child: new GestureDetector(
                child: new JobCard(
                  heightPercent: 25,
                  widthModifier: 5,
                  title:  jobs[index].title,
                  description:  jobs[index].description,
                  skills:  jobs[index].skills,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return JobDetailView(
                          job: jobs[index],
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return build_ListView(context);
  }
}

class StatefulListView extends StatefulWidget {
  StatefulListView({Key key,this.jobs,this.isLoading=false, this.isCached =false}) : super(key: key);

  final List<Job> jobs;
  final bool isLoading;
  bool isCached;
//  final SetOffsetMethod setOffsetMethod;

  @override
  _StatefulListViewState createState() => new _StatefulListViewState();
}

class _StatefulListViewState extends State<StatefulListView> {

  ScrollController scrollController;
  bool isCached;

  _StatefulListViewState({Key key, this.isCached = false});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  List<String> loadingData = <String>[
    "                                         ",
    "                               ",
    "                                     ",
    "                                         ",
    "                               ",
    "                                     ",
    "                                         ",
  ];

  Future<Null> _refresh() async {
    Timer(Duration(milliseconds: 350), () {
      setState(() {
        isCached = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController(
//        initialScrollOffset: widget.getOffsetMethod()
    );
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isLoading?RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: JobberTheme.accentColor,
      child: ListView.builder(
          itemCount: widget.jobs.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: index==0?const EdgeInsets.only(top: 25, bottom: 5):const EdgeInsets.only(bottom: 5),
              child: Container(
                child: new GestureDetector(
                  child: new Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      child: Text(widget.jobs[index].title),
                    ),
                  ),
                  onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute<void>(
//                        builder: (BuildContext context) {
//                          return JobDetailView(
//                            job: widget.jobs[index],
//                          );
//                        }));
                  },
                ),
              ),
            );
          }),
    ):
    ListView.builder(
        itemCount: loadingData.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: index==0?const EdgeInsets.only(top: 25, bottom: 5):const EdgeInsets.only(bottom: 5),
            child: Container(
              child: new GestureDetector(
                child: new Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child:  Shimmer.fromColors(
                        baseColor: JobberTheme.shimmerBaseColor(context),
                        highlightColor: JobberTheme.shimmerHighlightColor(context),
                        period: Duration(seconds: 1),
                        direction: ShimmerDirection.ltr,
                        child: Text(loadingData[index],style: TextStyle(backgroundColor: Color(0xFF000000)),)
                    ),
                  ),
                ),
                onTap: () { },
              ),
            ),
          );
        });
  }
}