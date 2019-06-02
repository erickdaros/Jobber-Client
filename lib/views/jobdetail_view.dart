 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobDetailView extends StatefulWidget {

  static const String routeName = 'preference';

  final Proposal proposal;

  JobDetailView({Key key, @required this.proposal}): super(key: key);

  @override
  State createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool darkTheme = false;
  bool fullScreen = false;
  bool snapDashboard = false;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();

    super.initState();
  }

  @override
  void dispose() {
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

    List<Widget> skillChips = new List<Widget>();

    List<String> skills = widget.proposal.skills;
    skills.forEach((skill)=>skillChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: new ActionChip(
            label: Text(skill,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: JobberTheme.accentColor,
            onPressed: ()=>{},
          ),
        )
    ));

//    return Hero(
//      tag: 'propose_card'+widget.proposal.title,
      child:
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Hero(
            tag: 'propose_title'+widget.proposal.title,
            child: Material(
              color: Colors.transparent,
              child: Text(widget.proposal.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            )
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(top:25,left: 15,right: 15),
                child: Hero(
                  tag: 'propose_details'+widget.proposal.title,
                  child: Material(color: Colors.transparent, child: Text(widget.proposal.description))
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Hero(
                  tag: 'propose_skills'+widget.proposal.title,
                  child: Material(
                    color: Colors.transparent,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: skillChips
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
//    );
  }
}
