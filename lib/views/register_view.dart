import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobber/controllers/auth_controller.dart';
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/themes/jobber_theme.dart' as Themee;
import 'package:jobber/utils/network_utils.dart';
import 'package:jobber/utils/sysui_utils.dart';
import 'package:jobber/widgets/themed_appbar.dart';
import 'package:jobber/widgets/utils/bubble_indication_painter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'main_view.dart';

class RegisterView extends StatefulWidget {

  static String routeName = 'registerView';

  RegisterView({Key key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with SingleTickerProviderStateMixin {

  static const MethodChannel actionChannel = MethodChannel('method.channel');

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Container(
//        color: Color(0xFF5B0792),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              Themee.JobberTheme.loginGradientStart,
              Themee.JobberTheme.loginGradientEnd
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: new Scaffold(
        appBar: ThemedAppBar(
          themeData: Themee.JobberTheme.buildTheme(Brightness.dark),
          appBar: AppBar(
              title: Text("Nova Conta"),
              elevation: 0,
              backgroundColor: Colors.transparent,
          ),
        ),
        backgroundColor:  Colors.transparent,//Color(0xFF4E0886),//Color(0xFF5B0792),
//        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: constraints.maxHeight,

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 100.0),
                        child: Container(),
//                    child: new Image(
//                        width: 250.0,
//                        height: 191.0,
//                        fit: BoxFit.fill,
//                        image: new AssetImage('assets/login_logo.png')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.0),
                        child: Container(),//_buildMenuBar(context),
                      ),
                      Flexible(
                        child: _buildSignUp(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 450.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(myFocusNodeEmail);
                          },
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Nome",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(myFocusNodePassword);
                          },
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(myFocusNodePasswordConfirmation);
                          },
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Senha",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextSignup?FontAwesomeIcons.eye:FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                              onPressed: _toggleSignup,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePasswordConfirmation,
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmar",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextSignupConfirm?FontAwesomeIcons.eye:FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                              onPressed: _toggleSignupConfirm,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePasswordConfirmation,
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (v){
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmar",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextSignupConfirm?FontAwesomeIcons.eye:FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                              onPressed: _toggleSignupConfirm,
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Themee.JobberTheme.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "REGISTRAR",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () =>
                      showInSnackBar(context,_scaffoldKey,"SignUp button pressed")),
              Container(
                margin: EdgeInsets.only(top: 430.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Themee.JobberTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Themee.JobberTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Themee.JobberTheme.loginGradientEnd,
                        Themee.JobberTheme.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Themee.JobberTheme.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "REGISTRAR",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () =>
                        showInSnackBar(context,_scaffoldKey,"SignUp button pressed")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//    setState(() {
//      scaffoldBackground = Color(0xFFFF0000);
//    });
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//    setState(() {
//      scaffoldBackground = Color(0xFF5B0792);
//    });
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}