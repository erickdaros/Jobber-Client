import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/widgets/gesturedetector_appbar.dart';
import 'package:jobber/widgets/json_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewJobView extends StatefulWidget {

  static const String routeName = 'newJobView';

  final Proposal proposal;

  NewJobView({Key key, @required this.proposal}): super(key: key);

  @override
  State createState() => _NewJobViewState();
}

class _NewJobViewState extends State<NewJobView> {
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

  final _formKey = GlobalKey<FormState>();
  String form = json.encode([
    {
      "type": "Input",
      "id" : "0",
      "title": "Título",
      "style": {
        "placeholder": "Título",
        "helperText" : "Título do novo Job",
        "maxLength" : 30,
      }
    },
    {
      "type": "TextArea",
      "id" : "_campo_madeira21",
      "title": "Descrição",
      "style": {
        "placeholder": "Descrição",
        "helperText" : "Descrição completa do novo Job",
        "maxLength" : 2000,
      }
    },
    {
      "type": "Date",
      "id" : "_campo_madeira21",
      "title": "Data de Nascimento",
      "style": {
        "placeholder": "Prazo máximo",
      }
    },
    {
      "type": "TextArea",
      "id" : "_campo_madeira21",
      "title": "Descrição completa do novo Job",
      "style": {
        "placeholder": "Skills",
      }
    },
  ]);
  dynamic response;

  @override
  Widget build(BuildContext context) {

//    return Hero(
//      tag: 'propose_card'+widget.proposal.title,
    child:
    return Theme(
      data: JobberTheme.buildTheme(Brightness.dark),
      child: Scaffold(
        backgroundColor: JobberTheme.accentColor,
        key: _scaffoldKey,
        appBar: GestureDetectorAppBar(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          appBar: AppBar(
            backgroundColor: JobberTheme.accentColor,
//            elevation: 0,
            title: Text("Novo Job",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
              ),
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CForm(
                    form: form,
                    padding: 10,
                    formKey: _formKey,
                    onChanged: (dynamic response) {
                      this.response = response;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: MaterialButton(
                      color: JobberTheme.white,
                      textColor: JobberTheme.purple,
                      child: Text("Finalizar"),
                      onPressed: (){},
                    ),
                  )
                ],
              ),
          ),
        ),
      ),
    );
//    );
  }
}
