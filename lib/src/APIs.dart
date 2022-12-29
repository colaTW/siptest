import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class APIs {
  var url = 'rsd.edwardforce.tw';


  getbanner()async{
    var uri = Uri.https('baotai.edwardforce.tw','/api/v1/home/banner/list',);
    var client = http.Client();
    var response = await client.get(uri,);
    // print(response.body);
    return (response.body);
  }
  getlist_member(String token,var type,var Category,var items,int pages)async{
    var params = Map<String, String>();
    var body= Map<String, String>();
    body["projectHandlerType"]=type.toString();
    body['page']=pages.toString();
    body['limit']="5";

    if(Category!=0){body['projectCategoryId']=Category.toString();}
    if(items!=null){body['projectItemId']=items.toString();}
    params["Authorization"] = ":Bearer "+token;
    params["Content-Type"]="application/json";
    var uri = Uri.https(url,'/api/member/project/one',body);
    print(body);
    var client = http.Client();
    var response = await client.get(uri,headers:params);
    // print(response.body);
    return (response.body);
  }


  login_member(String ac,String pas) async{
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"]="application/json";
    params["account"] = ac;
    params["password"] = pas;print(params);
    var body=json.encode(params);
    var client = http.Client();
    print(body);
    var uri = Uri.https(url,'/api/member/user/login');
    var response = await client.post(uri, body: body,headers:header);
    print(response.body);
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
  register_member(String constructionId,String name,String account,String password,String confirmPassword,String mobile,String email) async{
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"]="application/json";
    params["constructionId"] = constructionId;
    params["name"] = name;
    params["account"] = account;
    params["password"] = password;
    params["confirmPassword"] = confirmPassword;
    params["mobile"] = mobile;
    params["email"] = email;
    var body=json.encode(params);
    var client = http.Client();
    var uri = Uri.https(url,'/api/member/user/register');
    var response = await client.post(uri, body: body,headers:header);
    print(response.body);
    return (response.body);
  }
  uploadimg_project(String tk,var img,var name)async{
    var params = Map<String, String>();
    var body= Map<String, String>();
    body['fileName']=name.toString();
    body['file']="data:image/jpeg;base64,"+img;
    params["Authorization"] = ":Bearer "+tk;

    print(body);
    var client = http.Client();
    var uri = Uri.https(url,'/api/member/project/image/one');
    var response = await client.post(uri,headers:params,body:body);
    print("body"+response.body);
    return (response.body);
  }
  menberfix(var tk,var info) async{
    var params = Map<String, String>();
    params["Content-Type"]="application/json";
    params["Authorization"] = ":Bearer "+tk;
    var client = http.Client();
    var body=json.encode(info);
    print(body);
    var uri = Uri.https(url,'/api/member/project/one');
    var response = await client.post(uri,body:body,headers:params);
    print("here"+response.body);
    return (response.body);
  }
}