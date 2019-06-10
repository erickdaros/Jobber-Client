import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobber/controllers/api_controller.dart';
import 'package:jobber/controllers/auth_controller.dart';
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/models/skill_model.dart';
import 'package:jobber/models/user_model.dart';
import 'package:jobber/themes/jobber_theme.dart' as Themee;
import 'package:jobber/utils/network_utils.dart';
import 'package:jobber/utils/sysui_utils.dart';
import 'package:jobber/widgets/themed_appbar.dart';

import 'main_view.dart';

class CompleteRegisterView extends StatefulWidget {

  static String routeName = 'completeRegisterView';

  final User user;
  final List<Skill> skills;

  CompleteRegisterView({Key key, this.user, this.skills}) : super(key: key);

  @override
  _CompleteRegisterViewState createState() => _CompleteRegisterViewState(user: user, skills: skills);
}

class _CompleteRegisterViewState extends State<CompleteRegisterView> with SingleTickerProviderStateMixin {

  static const MethodChannel actionChannel = MethodChannel('method.channel');

  final User user;
  final List<Skill> skills;

  _CompleteRegisterViewState({Key key, @required this.user, @required this.skills});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePasswordConfirmation = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  bool _isLoginLoading = false;

  Color scaffoldBackground = Color(0xFF4E0886);

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
  new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  Future onLoginPressed() async {
    //TODO validate fields
    if(_isLoginLoading==false){
      if(loginEmailController.text==""&&loginPasswordController.text==""){
        showInSnackBar(context,_scaffoldKey,"Preencha os campos de login!");
      }else if(loginEmailController.text==""){
        showInSnackBar(context,_scaffoldKey,"Preencha o campo email!");
      }else if(loginPasswordController.text==""){
        showInSnackBar(context,_scaffoldKey,"Preencha o campo senha!");
      }else{
        setState(() {
          _isLoginLoading = true;
        });
        await NetworkUtils.isConnected().then((isConnected) async {
          if(isConnected){
            await AuthController.login(
              loginEmailController.text,
              loginPasswordController.text,
            ).then((loginResponse){
              if(loginResponse!=null){
                showInSnackBar(context,_scaffoldKey,"Logado com Sucesso!");
                StorageController.saveLoginResponse(loginResponse);
                SharedPreferencesController.setBool(StorageKeys.isUserLoggedIn, true);
//                Navigator.of(context)
//                    .pushReplacementNamed(MainView.routeName);
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return MainView(user: loginResponse.user,);
                    }
                ));
              }else{
                showInSnackBar(context,_scaffoldKey,"Usuário ou senha incorreto!");
              }
            });
          }else{
            showInSnackBar(context,_scaffoldKey,"Sem conexão!");
          }
        });
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  Future<void> _minimize() async{
    try{
      await actionChannel.invokeMethod('minimize');
    } on PlatformException catch(e) {
      print('${e.message}');
    }
  }

  Future<bool> _onWillPop(){
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    _minimize();
    return Future.value(false);
  }

  List<String> _defaultTools = <String>[
    'hammer',
    'chisel',
    'fryer',
    'fabricator',
    'customer',
  ];

  final Set<String> _selectedSkills = <String>{};

  bool isLoading = false;
  bool isSuccess = false;

  Widget _buildFAB(context, {key}) => FloatingActionButton(
      key: key,
      child: isLoading? Padding(padding: EdgeInsets.all(13) , child: CircularProgressIndicator(backgroundColor: Themee.JobberTheme.purple,),) : Icon(isSuccess? Icons.check : Icons.arrow_forward,
        color: Themee.JobberTheme.purple,
      ),
      backgroundColor: Colors.white,
      onPressed: () async {
        if(_selectedSkills.isEmpty){
          _showDialog("Certeza?",
            "Se você prosseguir sem ter selecionado nenhuma Skill não podera estar ingressando em projetos Freelancer de Jobs de outros uauários, apenas criar Jobs. Deseja Continuar?",
            <Widget>[
              new FlatButton(
                child: new Text("Sim",
                  style: TextStyle(
                      color: Themee.JobberTheme.purple
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await addUserSkills();
                },
              ),
              new FlatButton(
                child: new Text("Não",
                  style: TextStyle(
                      color: Themee.JobberTheme.purple
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }else{
          await addUserSkills();
        }
      }
  );

  bool showFAB = true;
  GlobalKey _fabKey = GlobalKey();
  final duration = const Duration(milliseconds: 300);

  _onFabTap(BuildContext context, User user) {
    // Hide the FAB on transition start
    setState(() => showFAB = false);

    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
          MainView(
            user: user,
          ),
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

  Future addUserSkills() async {
    setState(() {
      isLoading = true;
    });
//    List<Skill> dummySkills = new List<Skill>();
//    for(int i =0; i<10; i++){
//      dummySkills.add(
//        Skill(
//          id: i.toString(),
//          name: i.toString()
//        )
//      );
//    }
//
//    User localUser = new User(
//      id: "",
//      name: "",
//      freelancesQuantity: 1,
//      rating: 1,
//      description: "",
//      cellphone: "",
//      email: "",
//      skills: dummySkills,
//    );
//
//    List<String> skillsJSONArray = new List<String>();
//    Map<String, List<String>> body = {};
//
//    for(int i =0; i<localUser.skills.length; i++){
//      print(json.encode(localUser.skills[i]));
//      skillsJSONArray.add(
//        json.encode(localUser.skills[i]).toString()
//      );
//    }
//    body["skills"] = skillsJSONArray;
//    String skillsJSON = json.encode(body);
//    print(skillsJSON);

    User responseUser = await ApiController.addUserSkills(_selectedSkills.toList());
//    User responseUser = await StorageController.getLocalUser();
    StorageController.saveLocalUser(responseUser);

    if(responseUser!=null){
      for(int i=0; i<responseUser.skills.length; i++){
        print(responseUser.skills[i].name);
      }

      setState(() {
        isLoading = false;
        isSuccess = true;
      });

      await SharedPreferencesController.setBool(StorageKeys.isUserFirstSetupFinished, true);

      Timer(duration, () {
        setState(() => _onFabTap(context, responseUser));
      });
    }else{

      setState(() {
        isLoading = false;
        isSuccess = false;
      });

      showInSnackBar(context, _scaffoldKey, "Erro de conexão!");
    }

  }

  void _showDialog(String title, String content, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title,
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.normal,
            ),
          ),
          content: new Text(content,
            style: TextStyle(
              color: Color(0xFF777777),
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> filterChips = skills.map<Widget>((Skill skill) {
      return FilterChip(
        key: ValueKey<String>(skill.id),
        label: Text(skill.name,
          style: TextStyle(
            color: _selectedSkills.contains(skill.id) ? Colors.white : Colors.black,
          ),
        ),
        selected: _selectedSkills.contains(skill.id) ? true : false,
        selectedColor: Themee.JobberTheme.a700Purple,
        backgroundColor: Colors.white,
        onSelected: (bool value) {
          setState(() {
            if (!value) {
              _selectedSkills.remove(skill.id);
            } else {
              _selectedSkills.add(skill.id);
            }
          });
        },
      );
    }).toList();

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              Themee.JobberTheme.loginGradientStart,
              Themee.JobberTheme.loginGradientEnd
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
          ),
        ),
        child: new Scaffold(
          backgroundColor:  Colors.transparent,
          key: _scaffoldKey,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: ListView(
                  children: <Widget>[
                    ThemedAppBar(
                      themeData: Themee.JobberTheme.buildTheme(Brightness.dark),
                      appBar: AppBar(
                        title: Text("Quase lá!"),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(Icons.info,color: Colors.white,),
                          onPressed: (){
                            _showDialog("Falta pouco!",
                              "Antes de continuarmos selecione suas skills, caso não tenha uma ou deseje adicionar posteriomente basta avançar",
                              <Widget>[
                                new FlatButton(
                                  child: new Text("Ok",
                                    style: TextStyle(
                                      color: Themee.JobberTheme.purple
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Text("Para continuarmos, selecione suas Skills abaixo!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: _ChipsTile(label: 'Choose Tools (FilterChip)', children: filterChips),
                    ),
                  ],
                ),
              );
            }
          ),
          floatingActionButton: Visibility(
            visible: showFAB,
            child: _buildFAB(context, key: _fabKey),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    showFAB = true;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }
}

class _ChipsTile extends StatelessWidget {
  const _ChipsTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cardChildren = <Widget>[];
    if (children.isNotEmpty) {
      cardChildren.add(Wrap(
          children: children.map<Widget>((Widget chip) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: chip,
            );
          }).toList()));
    } else {
      final TextStyle textStyle = Theme.of(context).textTheme.caption.copyWith(fontStyle: FontStyle.italic);
      cardChildren.add(
          Semantics(
            container: true,
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
              padding: const EdgeInsets.all(8.0),
              child: Text('None', style: textStyle),
            ),
          ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cardChildren,
      ),
    );
  }
}