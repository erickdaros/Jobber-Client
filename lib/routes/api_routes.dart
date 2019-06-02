const String apiAddress = "c300d46d.ngrok.io";
const String apiPort = "";

class Routes{

  ApiRoutes api;

  Routes(){
    api = new ApiRoutes();
  }
}

class ApiRoutes{

  String home = "";
  AuthRoutes auth;

  ApiRoutes(){
    home = apiPort==null||apiPort==""?"http://"+apiAddress:"http://"+apiAddress+":"+apiPort;
    auth = new AuthRoutes(this);
  }

}

class AuthRoutes{
  String register;
  String login;

  AuthRoutes(ApiRoutes api){
    register = api.home+"/auth/register";
    login = api.home+"/auth/login";
  }
}