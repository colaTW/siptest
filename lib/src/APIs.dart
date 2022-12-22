import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class APIs {
  var url = '';

  getDomainIP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url=(prefs.getString("DomainIP")??"");
    return url;
  }

  registered(String name,String mobile,String pas) async{
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"]="application/json";
    params["name"] = name;
    params["mobile"] = mobile;
    params["password"] = pas;
    print(params);
    var body=json.encode(params);
    var client = http.Client();
    print(body);
    var uri = Uri.https(url,'/riway/api/v1/client/create');
    var response = await client.post(uri, body: body,headers:header).timeout(const Duration(seconds: 5));
    print(response.body);
    return (response.body);
  }

  login(String mobile,String pas,String notify_token) async{
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"]="application/json";
    params["mobile"] = mobile;
    params["password"] = pas;
    params["notify_token"] = notify_token;
    print(params);
    var body=json.encode(params);
    var uri = Uri.https(url,'/riway/api/v1/client/login');

    var client = http.Client();
    var response = await client.post(uri, body: body,headers:header).timeout(const Duration(seconds: 5));
    return (response.body);
  }
  getqrcode(String token)async{
    print(token);
    var params = Map<String, String>();
    var body= Map<String, String>();
    params["Authorization"] = "Bearer "+token;
    var uri = Uri.https(url,'/riway/api/v1/client/permission/qrcode',body);
    //print(uri);
    var client = http.Client();
    var response = await client.get(uri,headers:params).timeout(const Duration(seconds: 5));
    print(response);
    return (response.body);
  }
  changepwd(String account,String newpwd)async{
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"]="application/json";
    params["account"] = account;
    params["password"] = newpwd;
    print(params);
    var body=json.encode(params);
    var client = http.Client();
    print(body);
    var uri = Uri.https(url,'/riway/api/v1/client/change/pwd');
    var response = await client.post(uri, body: body,headers:header);
    print(response.body);
    return (response.body);
  }


}