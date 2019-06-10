import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobber/controllers/api_controller.dart';
import 'package:jobber/controllers/auth_controller.dart';
import 'package:jobber/controllers/sharedpreferences_controller.dart';
import 'package:jobber/controllers/storage_controller.dart';
import 'package:jobber/models/skill_model.dart';
import 'package:jobber/themes/jobber_theme.dart' as Theme;
import 'package:jobber/utils/network_utils.dart';
import 'package:jobber/utils/sysui_utils.dart';
import 'package:jobber/views/completeregister_view.dart';
import 'package:jobber/widgets/cform/utils/cellphone_textinputformatter.dart';
import 'package:jobber/widgets/utils/bubble_indication_painter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_masked_text/flutter_masked_text.dart';


import 'main_view.dart';

class LoginView extends StatefulWidget {
  static String routeName = 'loginView';

  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  static const MethodChannel actionChannel = MethodChannel('method.channel');

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePasswordConfirmation = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeCellphone = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  bool _isLoginLoading = false;
  bool _isRegisterLoading = false;

  Color scaffoldBackground = Color(0xFF4E0886);

  bool isNameInvalid = false;
  bool isEmailInvalid = false;
  bool isCallphoneInvalid = false;
  bool isPasswordInvalid = false;
  bool isPasswordConfirmationInvalid = false;

  TextEditingController signupEmailController = new TextEditingController();
  var signupCellphoneController = new MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;
  ScrollController _scrollController = new ScrollController();

  Color left = Colors.black;
  Color right = Colors.white;

  Future onLoginPressed() async {
    //TODO validate fields
    if (_isLoginLoading == false) {
      if (loginEmailController.text == "" &&
          loginPasswordController.text == "") {
        showInSnackBar(context, _scaffoldKey, "Preencha os campos de login!");
      } else if (loginEmailController.text == "") {
        showInSnackBar(context, _scaffoldKey, "Preencha o campo email!");
      } else if (loginPasswordController.text == "") {
        showInSnackBar(context, _scaffoldKey, "Preencha o campo senha!");
      } else {
        setState(() {
          _isLoginLoading = true;
        });
        await NetworkUtils.isConnected().then((isConnected) async {
          if (isConnected) {
            await AuthController.login(
              loginEmailController.text,
              loginPasswordController.text,
            ).then((loginResponse) {
              if (loginResponse != null) {
                print("loginResponse: "+loginResponse.toString());
                showInSnackBar(context, _scaffoldKey, "Logado com Sucesso!");
                StorageController.saveLoginResponse(loginResponse);
                SharedPreferencesController.setBool(
                    StorageKeys.isUserLoggedIn, true);
//                Navigator.of(context)
//                    .pushReplacementNamed(MainView.routeName);
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return MainView(
                    user: loginResponse.user,
                  );
                }));
              } else {
                showInSnackBar(
                    context, _scaffoldKey, "Usuário ou senha incorreto!");
              }
            });
          } else {
            showInSnackBar(context, _scaffoldKey, "Sem conexão!");
          }
        });
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEmailAlreadyRegistered = false;

  Future onRegisterPressed() async {
    if (_formKey.currentState.validate()) {
      if (_isRegisterLoading == false) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
        setState(() {
          _isRegisterLoading = true;
        });
        await NetworkUtils.isConnected().then((isConnected) async {
          if (isConnected) {
            String cellphone = signupCellphoneController.text;
            cellphone=cellphone.replaceAll("(", "");
            cellphone=cellphone.replaceAll(")", "");
            cellphone=cellphone.replaceAll("-", "");
            cellphone=cellphone.trim();
            print(cellphone);
            await AuthController.register(
              signupNameController.text,
              signupEmailController.text,
              signupConfirmPasswordController.text,
              cellphone,
            ).then((registerResponse) async {
              if (registerResponse.success) {
                showInSnackBar(context, _scaffoldKey, "Registrado com Sucesso!");
                await StorageController.saveRegisterResponse(registerResponse);
                SharedPreferencesController.setBool(
                    StorageKeys.isUserLoggedIn, true);
//                Navigator.of(context)
//                    .pushReplacementNamed(MainView.routeName);
                await SharedPreferencesController.setBool(StorageKeys.isUserFirstSetupFinished,false);
                List<Skill> skills = await ApiController.getJobberSkills();
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return CompleteRegisterView(
                        user: registerResponse.user,
                        skills: skills,
                      );
                    }));
              }
              else {
                if(registerResponse.message!=null){
                  showInSnackBar(
                      context, _scaffoldKey, registerResponse.message);
                  if(registerResponse.message=="Email já cadastrado"){
                    setState(() {
                      autoValidate = true;
                      isEmailAlreadyRegistered = true;
                    });
                  }else{
                    setState(() {
                      autoValidate = false;
                      isEmailAlreadyRegistered = false;
                    });
                  }
                }
              }
            });
          } else {
            showInSnackBar(context, _scaffoldKey, "Sem conexão!");
          }
        });
        setState(() {
          _isRegisterLoading = false;
        });
      }
    } else {
      setState(() {
        autoValidate = true;
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }


//    Navigator.of(context)
//        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
//      return RegisterView();
//    }));
  }

  Future<void> _minimize() async {
    try {
      await actionChannel.invokeMethod('minimize');
    } on PlatformException catch (e) {
      print('${e.message}');
    }
  }

  Future<bool> _onWillPop() {
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    _minimize();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
//        color: Color(0xFF5B0792),
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Theme.JobberTheme.loginGradientStart,
                Theme.JobberTheme.loginGradientEnd
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: new Scaffold(
          backgroundColor: Colors.transparent,
          //Color(0xFF4E0886),//Color(0xFF5B0792),
//        resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: new Image(
                          width: 250.0,
                          height: 191.0,
                          fit: BoxFit.fill,
                          image: new AssetImage('assets/login_logo.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 17.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Entrar",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Registrar",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Stack(
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
                    height: 190.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            cursorColor: Theme.JobberTheme.purple,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(myFocusNodePasswordLogin);
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
                                size: 22.0,
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
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
                          child: TextField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            cursorColor: Theme.JobberTheme.purple,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Senha",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                                onPressed: _toggleLogin,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 170.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.JobberTheme.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.JobberTheme.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Theme.JobberTheme.loginGradientEnd,
                          Theme.JobberTheme.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.JobberTheme.loginGradientEnd,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: _isLoginLoading
                            ? CircularProgressIndicator()
                            : Text(
                                "ENTRAR",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontFamily: "WorkSansBold"),
                              ),
                      ),
                      onPressed: () => onLoginPressed()),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Esqueceu a senha?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Ou",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar(
                      context, _scaffoldKey, "Facebook pressionado"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar(
                      context, _scaffoldKey, "Google pressionado"),
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: new SvgPicture.asset(
                        'assets/G_Logo.svg',
                        semanticsLabel: 'Conta Google',
                        height: 25,
                        width: 25,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool autoValidate = false;

  int invalidCounter = 0;

  Widget _buildSignUp(BuildContext context) {

//    print("Invalid :"+invalidCounter.toString());

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.bottomCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Card(
                      elevation: 2.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          autovalidate: autoValidate,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20, left: 25.0, right: 25.0),
                                child: TextFormField(
                                  focusNode: myFocusNodeName,
                                  controller: signupNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(myFocusNodeEmail);
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
                                    hintText: "Nome Completo",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
                                  ),
                                  validator: (value){
                                    if(value.isEmpty){
                                      if(!isNameInvalid){
                                        invalidCounter++;
                                        isNameInvalid = true;
                                      }
                                      return "O campo não pode ser vazio";
                                    }
                                    if(isNameInvalid){
                                      invalidCounter--;
                                      isNameInvalid = false;
                                    }
                                    return null;
                                  },
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
                                  onEditingComplete: (){
                                    setState(() {
                                      isEmailAlreadyRegistered = false;
                                    });
                                  },
                                  onFieldSubmitted: (v) {
                                    setState(() {
                                      isEmailAlreadyRegistered = false;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(myFocusNodeCellphone);
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
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
                                  ),
                                  validator: (value){
                                    if(value.isEmpty){
                                      if(!isEmailInvalid){
                                        invalidCounter++;
                                        isEmailInvalid = true;
                                      }
                                      return "O campo não pode ser vazio";
                                    }
                                    if(!value.contains("@")){
                                      if(!isEmailInvalid){
                                        invalidCounter++;
                                        isEmailInvalid = true;
                                      }
                                      return "Valor inserido inválido";
                                    }
                                    if(!value.contains(".")){
                                      if(!isEmailInvalid){
                                        invalidCounter++;
                                        isEmailInvalid = true;
                                      }
                                      return "Valor inserido inválido";
                                    }
                                    if(isEmailAlreadyRegistered){
                                      return "Email já cadastrado";
                                    }
                                    if(isEmailInvalid){
                                      invalidCounter--;
                                      isEmailInvalid = false;
                                    }
                                    return null;
                                  },
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
                                  focusNode: myFocusNodeCellphone,
//                            inputFormatters: <TextInputFormatter> [
//                              WhitelistingTextInputFormatter.digitsOnly,
//                              new CellphoneTextInputFormatter(),
//                            ],
                                  controller: signupCellphoneController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  maxLength: 15,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(myFocusNodePassword);
                                  },
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  validator: (value){
                                    if(value.isEmpty){
                                      if(!isCallphoneInvalid){
                                        invalidCounter++;
                                        isCallphoneInvalid = true;
                                      }
                                      return "O campo não pode ser vazio";
                                    }
                                    if(value.length<15){
                                      if(!isCallphoneInvalid){
                                        invalidCounter++;
                                        isCallphoneInvalid = true;
                                      }
                                      return "Valor inserido inválido";
                                    }
                                    if(isCallphoneInvalid){
                                      invalidCounter--;
                                      isCallphoneInvalid = false;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: '',
                                    icon: Icon(
                                      FontAwesomeIcons.mobileAlt,
                                      color: Colors.black,
                                    ),
                                    hintText: "Celular",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
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
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(myFocusNodePasswordConfirmation);
                                  },
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  validator: (value){
                                    if(value.isEmpty){
                                      if(!isPasswordInvalid){
                                        invalidCounter++;
                                        isPasswordInvalid = true;
                                      }
                                      return "O campo não pode ser vazio";
                                    }
                                    if(isPasswordInvalid){
                                      invalidCounter--;
                                      isPasswordInvalid = false;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: "Senha",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureTextSignup
                                            ? FontAwesomeIcons.eye
                                            : FontAwesomeIcons.eyeSlash,
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
                                  textInputAction: TextInputAction.go,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());



                                    onRegisterPressed();
                                  },
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  validator: (value){
                                    if(value.isEmpty){
                                      if(!isPasswordConfirmationInvalid){
                                        invalidCounter++;
                                        isPasswordConfirmationInvalid = true;
                                      }
                                      return "O campo não pode ser vazio";
                                    }
                                    if(value!=signupPasswordController.text){
                                      return "As senhas não coincidem";
                                    }
                                    if(isPasswordConfirmationInvalid){
                                      invalidCounter--;
                                      isPasswordConfirmationInvalid = false;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    hintText: "Confirmar",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureTextSignupConfirm
                                            ? FontAwesomeIcons.eye
                                            : FontAwesomeIcons.eyeSlash,
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: Container(
//                        margin: EdgeInsets.only(top: 515.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.JobberTheme.loginGradientStart,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Theme.JobberTheme.loginGradientEnd,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                          ],
                          gradient: new LinearGradient(
                              colors: [
                                Theme.JobberTheme.loginGradientEnd,
                                Theme.JobberTheme.loginGradientStart
                              ],
                              begin: const FractionalOffset(0.2, 0.2),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: Theme.JobberTheme.loginGradientEnd,
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: _isRegisterLoading
                                  ? CircularProgressIndicator()
                                  :Text(
                                "REGISTRAR",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontFamily: "WorkSansBold"),
                              ),
                            ),
                            onPressed: onRegisterPressed
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
