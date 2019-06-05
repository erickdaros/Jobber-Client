const String apiAddress = "jobber.sytes.net";
const String apiPort = "";

class Routes{

  ApiRoutes api;

  Routes(){
    api = new ApiRoutes();
  }
}

class ApiRoutes{

  String home = "";
  String createJob = "/api/job";
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