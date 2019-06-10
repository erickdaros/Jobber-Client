import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobber/models/job_model.dart';
import 'package:jobber/themes/jobber_theme.dart';
import 'package:jobber/widgets/cform/utils/date_textinputformatter.dart';
import 'package:jobber/widgets/gesturedetector_appbar.dart';
import 'package:jobber/widgets/json_forms.dart';
import 'package:jobber/widgets/skill_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdownfield/dropdownfield.dart';

class NewJobView extends StatefulWidget {

  static const String routeName = 'newJobView';

  final Job proposal;

  NewJobView({Key key, @required this.proposal}): super(key: key);

  @override
  State createState() => _NewJobViewState();
}

class _NewJobViewState extends State<NewJobView> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  DateTextInputFormatter date = new DateTextInputFormatter();

  TextEditingController titleTFController = new TextEditingController();
  TextEditingController descriptionTFController = new TextEditingController();
  TextEditingController dateTFController = new TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode dateFocusNode = FocusNode();



  bool darkTheme = false;
  bool fullScreen = false;
  bool snapDashboard = false;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();
    addSkillTextField();
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

  String formatZero(int value){
    return value<10?"0"+value.toString():value.toString();
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1801, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateTFController.text = formatZero(picked.day)+"/"
            +formatZero(picked.month)+"/"
            +picked.year.toString();
      });
  }

  String getRandomKeyValue(){
    final _random = new Random();
    List<String> alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
    int next(int min, int max) => min + _random.nextInt(max - min);
    String key = ""+alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+
        alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+
        alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+alphabet[next(0,25)]+
        alphabet[next(0,25)]+next(0,999).toString();
    return key;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  bool addSkillButtonEnabled = false;
  List<Key> skillsTextFieldsKeys = new List<Key>();
  List<Widget> skillsTextFields = new List<Widget>();
  List<TextEditingController> skillsTextFieldsControllers = new List<TextEditingController>();

  List<String> skills = <String>[
    "PHP",
    "JS",
    "Node.JS",
    "Flutter",
  ];

  bool showAdd = false;

  void addSkillTextField(){
    setState(() {
      skillsTextFieldsControllers.add(
          new TextEditingController()
      );
      skillsTextFieldsKeys.add(
          Key(getRandomKeyValue())
      );
      skillsTextFields.add(
          new SkillTextField(
            key: skillsTextFieldsKeys[skillsTextFieldsKeys.length-1],
            controller: skillsTextFieldsControllers[skillsTextFieldsControllers.length-1],
            skills: skills,
            onGetPosition: (key){
              return getSkillTextFieldPosition(key);
            },
            onDelete: (index){
              removeSkillTextField(index);
            },
            enableAdd: (){
              setState(() {
                showAdd = true;
              });
            },
          ),
      );
      try{
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      }catch(err){}

    });

  }

  int getSkillTextFieldPosition(Key skillsTextFieldKey){
    for(int i = 0; i<skillsTextFieldsKeys.length; i++){
      if(skillsTextFieldKey.toString()==skillsTextFieldsKeys[i].toString()){
        return i;
      }
    }
    return -1;
  }

  void removeSkillTextField(int index){
    setState(() {
      skillsTextFieldsKeys.removeAt(index);
      skillsTextFields.removeAt(index);
      skillsTextFieldsControllers.removeAt(index);
    });
  }

  List<String> getSkills(){
    List<String> skills = new List<String>();
    if(skillsTextFieldsControllers.length>0){
      for(int i = 0; i<skillsTextFieldsControllers.length; i++){
        skills.add(
            skillsTextFieldsControllers[i].text
        );
      }
      return skills;
    }
    return null;
  }

  bool _autoValidate = false;

  void validateFields(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {

//    return Hero(
//      tag: 'propose_card'+widget.proposal.title,
    child:
    return Theme(
      data: JobberTheme.buildTheme(Brightness.dark),
      child: Scaffold(
        backgroundColor: JobberTheme.purple,
        key: _scaffoldKey,
        appBar: GestureDetectorAppBar(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          appBar: AppBar(
            backgroundColor: JobberTheme.purple,
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
              controller: _scrollController,
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 25,bottom: 10),
                            child: TextFormField(
                                cursorColor: JobberTheme.white,
                              focusNode: titleFocusNode,
                              controller: titleTFController,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v){
                                FocusScope.of(context).requestFocus(descriptionFocusNode);
                              },
                              validator: (String value) {
                                if(value.length < 5)
                                  return 'Mínimo 5 caracteres válidos';
                                if(value.isEmpty){
                                  return "Este campo não pode ser vazio";
                                }
                                if(value.trim()==null||value.trim()==""){
                                  return 'Mínimo 5 caracteres válidos';
                                }
                                else
                                  return null;
                              },
//                      controller: teController,
//                      keyboardType: widget.type==CFTextFieldType.email?TextInputType.emailAddress: widget.type==CFTextFieldType.date? TextInputType.datetime : TextInputType.text,
                                decoration: new InputDecoration(
//                        prefixIcon: widget.prefixIcon == null ? null : new Icon(stringToIcon(widget.prefixIcon)),
//                        suffixIcon: widget.type==CFTextFieldType.date ? dateAction() : null,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: JobberTheme.whiteAppBar
                                      )
                                  ),
                                  isDense: true,
                                  labelText: "Título",
                                  helperText: "Título do novo Job",
//                        helperStyle: TextStyle(
//                          color: widget.type==CFTextFieldType.date? Color(0x00FFFFFF) : null,
//                        ),
                                ),
//                      maxLines: widget.maxLines,
                                maxLength: 50,
                                onSaved: (value){},
//                      obscureText: widget.type==CFTextFieldType.password,
//                      inputFormatters: widget.type==CFTextFieldType.date ? <TextInputFormatter> [
//                        WhitelistingTextInputFormatter.digitsOnly,
//                        date,
//                      ] : null
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              cursorColor: JobberTheme.white,
                              textInputAction: TextInputAction.next,
                              focusNode: descriptionFocusNode,
                              controller: descriptionTFController,
                              onFieldSubmitted: (v){
                                FocusScope.of(context).requestFocus(dateFocusNode);
                              },
//                      controller: teController,
//                      keyboardType: widget.type==CFTextFieldType.email?TextInputType.emailAddress: widget.type==CFTextFieldType.date? TextInputType.datetime : TextInputType.text,
                              decoration: new InputDecoration(
//                        prefixIcon: widget.prefixIcon == null ? null : new Icon(stringToIcon(widget.prefixIcon)),
//                        suffixIcon: widget.type==CFTextFieldType.date ? dateAction() : null,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: JobberTheme.whiteAppBar
                                    )
                                ),
                                isDense: true,
                                labelText: "Descrição",
                                helperText: "Descrição do novo Job",
//                        helperStyle: TextStyle(
//                          color: widget.type==CFTextFieldType.date? Color(0x00FFFFFF) : null,
//                        ),
                              ),
                              maxLines: 10,
                              maxLength: 50,
                              onSaved: (value){},
//                      obscureText: widget.type==CFTextFieldType.password,
                              validator: (String value) {
                                if(value.length < 5)
                                  return 'Mínimo 5 caracteres válidos';
                                if(value.isEmpty){
                                  return "Este campo não pode ser vazio";
                                }
                                if(value.trim()==null||value.trim()==""){
                                  return 'Mínimo 5 caracteres válidos';
                                }
                                else
                                  return null;
                              },
//                      inputFormatters: widget.type==CFTextFieldType.date ? <TextInputFormatter> [
//                        WhitelistingTextInputFormatter.digitsOnly,
//                        date,
//                      ] : null
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              cursorColor: JobberTheme.white,
                                textInputAction: TextInputAction.next,
                              focusNode: dateFocusNode,
                              controller: dateTFController,
//                            onFieldSubmitted: (v){
//                              FocusScope.of(context).requestFocus();
//                            },
//                      controller: teController,
                              keyboardType: TextInputType.datetime,
                              decoration: new InputDecoration(
//                        prefixIcon: widget.prefixIcon == null ? null : new Icon(stringToIcon(widget.prefixIcon)),
                                suffixIcon: IconButton(
                                  icon: new Icon(Icons.today),
                                  onPressed: (){
                                    _selectDate(context);
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: JobberTheme.whiteAppBar
                                  )
                                ),
                                isDense: true,
                                labelText: "Prazo máximo",
                                helperText: "",
                                helperStyle: TextStyle(
                                  color: Color(0x00FFFFFF),
                                ),
                              ),
//                      maxLines: widget.maxLines,
                              maxLength: 10,
                              onSaved: (value){},
//                      obscureText: widget.type==CFTextFieldType.password,
                              validator: (value) {
                                if(value.isEmpty){
                                  return "Este campo não pode ser vazio";
                                }else{
                                  try{
                                    List<String> dateArr = value.split("/");
                                    print(value.split("/")[0]);
                                    DateTime date = DateTime(int.parse(dateArr[2]),int.parse(dateArr[1]),int.parse(dateArr[0]));
                                    print(date.toIso8601String());
                                    return null;
                                  }catch(err){
                                    return "Data inválida";
                                  }
                                }
                              },
                            inputFormatters:  <TextInputFormatter> [
                              WhitelistingTextInputFormatter.digitsOnly,
                              date,
                            ]
                            ),
                          ),
//                        Padding(
//                          padding: const EdgeInsets.only(bottom: 10),
//                          child: TextFormField(
//                            cursorColor: JobberTheme.white,
//                            textInputAction: TextInputAction.done,
////                      controller: teController,
////                      keyboardType: widget.type==CFTextFieldType.email?TextInputType.emailAddress: widget.type==CFTextFieldType.date? TextInputType.datetime : TextInputType.text,
//                            decoration: new InputDecoration(
////                        prefixIcon: widget.prefixIcon == null ? null : new Icon(stringToIcon(widget.prefixIcon)),
////                        suffixIcon: widget.type==CFTextFieldType.date ? dateAction() : null,
//                              border: OutlineInputBorder(
//                                  borderSide: BorderSide(
//                                      color: JobberTheme.whiteAppBar
//                                  )
//                              ),
//                              isDense: true,
//                              labelText: "Skills",
////                              helperText: "Descrição do novo Job",
////                        helperStyle: TextStyle(
////                          color: widget.type==CFTextFieldType.date? Color(0x00FFFFFF) : null,
////                        ),
//                            ),
//                            maxLines: 10,
//                            maxLength: 50,
//                            onSaved: (value){},
////                      obscureText: widget.type==CFTextFieldType.password,
//                            validator: (value) {
//                              if(value.isEmpty){
//                                return "Este campo não pode ser vazio";
//                              }
//                            },
////                      inputFormatters: widget.type==CFTextFieldType.date ? <TextInputFormatter> [
////                        WhitelistingTextInputFormatter.digitsOnly,
////                        date,
////                      ] : null
//                          ),
//                        ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text("Skill(s):",
                              style: TextStyle(
                                fontSize: 17
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: skillsTextFields,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          color: JobberTheme.white,
                          textColor: JobberTheme.purple,
                          child: Text("NOVA SKILL"),
                          onPressed: skillsTextFieldsControllers.last.text==""?null:skillsTextFieldsControllers.last.text.length>2||showAdd?(){
                            addSkillTextField();
                            setState(() {
                              showAdd = false;
                            });
                          }:null
//                          onPressed: false ? () {} : null
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: MaterialButton(
                        color: JobberTheme.white,
                        textColor: JobberTheme.purple,
                        child: Text("CRIAR JOB"),
                        onPressed: (){
                          validateFields();
                          Job newJob = new Job(
                            titleTFController.text,
                            descriptionTFController.text,
                            dateTFController.text,
                            getSkills()!=null?getSkills():[""]
                          );
                          print(newJob.toString());
                        },
                      ),
                    )
                  ],
                ),
              ),
          ),
        ),
      ),
    );
//    );
  }
}
