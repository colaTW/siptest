import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class APIs {
  var url = 'ip-intercom.reddotsolution.com';
  var path='/app/api';
  //var url = 'community.edwardforce.tw/api';
//  var path='api'

  getbanner() async {
    var uri = Uri.https(
      'baotai.edwardforce.tw',
      '/api/v1/home/banner/list',
    );
    var client = http.Client();
    var response = await client.get(
      uri,
    );
    // print(response.body);
    return (response.body);
  }

  getlist_member(
      String token, var type, var Category, var items, int pages) async {
    var params = Map<String, String>();
    var body = Map<String, String>();
    body["projectHandlerType"] = type.toString();
    body['page'] = pages.toString();
    body['limit'] = "5";

    if (Category != 0) {
      body['projectCategoryId'] = Category.toString();
    }
    if (items != null) {
      body['projectItemId'] = items.toString();
    }
    params["Authorization"] = ":Bearer " + token;
    params["Content-Type"] = "application/json";
    var uri = Uri.https(url, path+'/member/project/one', body);
    print(body);
    var client = http.Client();
    var response = await client.get(uri, headers: params);
    // print(response.body);
    return (response.body);
  }
  getbulltinlist_member(
      String token, var title, var constructionId, var page,) async {
    var params = Map<String, String>();
    var body = Map<String, String>();
    body["title"] = title.toString();
    body['page'] = page.toString();
    body['limit']="5";
    body['constructionId'] =constructionId.toString();
    params["Authorization"] = ":Bearer " + token;
    params["Content-Type"] = "application/json";
    var uri = Uri.https(url, path+'/member/bulletin/list', body);
    print(body);
    var client = http.Client();
    var response = await client.get(uri, headers: params);
    // print(response.body);
    return (response.body);
  }

  login_member(String ac, String pas) async {
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"] = "application/json";
    params["account"] = ac;
    params["password"] = pas;
    print(params);
    var body = json.encode(params);
    var client = http.Client();
    print(body);
    var uri = Uri.https(url, path+'/member/user/login');
    var response = await client.post(uri, body: body, headers: header);
    print(response.body);
    return (response.body);
  }

  changepwd(String account, String newpwd) async {
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"] = "application/json";
    params["account"] = account;
    params["password"] = newpwd;
    print(params);
    var body = json.encode(params);
    var client = http.Client();
    print(body);
    var uri = Uri.https(url, '/riway/api/v1/client/change/pwd');
    var response = await client.post(uri, body: body, headers: header);
    print(response.body);
    return (response.body);
  }

  register_member(
      String constructionId,
      String name,
      String account,
      String password,
      String confirmPassword,
      String mobile,
      String email,
      String mobileNotifyToken) async {
    var params = Map<String, String>();
    var header = Map<String, String>();
    header["Content-Type"] = "application/json";
    params["name"] = name;
    params["account"] = account;
    params["password"] = password;
    params["confirmPassword"] = confirmPassword;
    params["mobile"] = mobile;
    params["email"] = email;
    params["mobileNotifyToken"] = mobileNotifyToken;
    var body = json.encode(params);
    var client = http.Client();
    var uri = Uri.https(url, path+'/member/user/register');
    var response = await client.post(uri, body: body, headers: header);
    print(response.body);
    return (response.body);
  }

  uploadimg_project(String tk, var img, var name) async {
    var params = Map<String, String>();
    var body = Map<String, String>();
    body['fileName'] = name.toString();
    body['file'] = "data:image/jpeg;base64," + img;
    params["Authorization"] = ":Bearer " + tk;

    print(body);
    var client = http.Client();
    var uri = Uri.https(url, path+'/member/project/image/one');
    var response = await client.post(uri, headers: params, body: body);
    print("body" + response.body);
    return (response.body);
  }

  managerfix(var tk, var info) async {
    var params = Map<String, String>();
    params["Content-Type"] = "application/json";
    params["Authorization"] = ":Bearer " + tk;
    var client = http.Client();
    var body = json.encode(info);
    print(body);
    var uri = Uri.https(url, path+'/manager/project/handler/one');
    var response = await client.post(uri, body: body, headers: params);
    print("here" + response.body);
    return (response.body);
  }
  menberfix(var tk, var info) async {
    var params = Map<String, String>();
    params["Content-Type"] = "application/json";
    params["Authorization"] = ":Bearer " + tk;
    var client = http.Client();
    var body = json.encode(info);
    print(body);
    var uri = Uri.https(url, path+'/member/project/one');
    var response = await client.post(uri, body: body, headers: params);
    print("here" + response.body);
    return (response.body);
  }

  bindcommunity(var tk, var houseID) async {
    var params = Map<String, String>();
    params["Authorization"] = ":Bearer " + tk;
    var body = Map<String, String>();
    body['hourseId'] = houseID.toString();
    var client = http.Client();
    print(body);
    var uri = Uri.https(url, path+'/member/user/bind/house');
    var response = await client.post(uri, body: body, headers: params);
    print("here" + response.body);
    return (response.body);
  }

  getmemberprofile(var tk) async {
    var params = Map<String, String>();
    params["Authorization"] = ":Bearer " + tk;
    params["Content-Type"] = "application/json";
    var uri = Uri.https(url, '/app/api/member/user/profile');
    var client = http.Client();
    var response = await client.get(uri, headers: params);
     print(response.body);
    return (response.body);
  }
  getcategorylist(var tk) async {
    var params = Map<String, String>();
    params["Authorization"] = ":Bearer " + tk;
    params["Content-Type"] = "application/json";
    var uri = Uri.https(url, '/app/api/member/project/category/item/options');
    var client = http.Client();
    var response = await client.get(uri, headers: params);
    // print(response.body);
    return (response.body);
  }
  startcall(var tk, var targetConstructionId, var fromHourseId,var targetHourseName) async {
    var params = Map<String, String>();
    params["Authorization"] = ":Bearer " + tk;
    var body = Map<String, String>();
    body['targetConstructionId'] = targetConstructionId.toString();
    body['targetHourseName'] = targetHourseName.toString();
    body['fromHourseId']=fromHourseId.toString();
    print("body"+body.toString());

    var client = http.Client();
    var uri = Uri.https(url, '/app/api/member/intercom/house/call');
    var response = await client.post(uri, body: body, headers: params);
    return (response.body);
  }

  answercall(var tk, var fromMemberId, var targetSipId,var fromtype) async {
    var params = Map<String, String>();
    params["Authorization"] = ":Bearer " + tk;
    var body = Map<String, String>();
    body['fromId'] = fromMemberId.toString();
    body['targetSipId'] = targetSipId.toString();
    body['fromType'] = fromtype.toString();
    var client = http.Client();
    print("body" + body.toString());
    var uri = Uri.https(url, '/app/api/member/intercom/house/pickup');
    var response = await client.post(uri, body: body, headers: params);
    print("here" + response.body);
    return (response.body);
  }
  getconstructioninfo(var code) async {
    var params = Map<String, String>();
    params["Content-Type"] = "application/json";
    var uri = Uri.https(url, '/app/api/member/construction/code/'+code);
    var client = http.Client();
    var response = await client.get(uri, headers: params);
    // print(response.body);
    return (response.body);
  }
  deleteaccount(var tk, var password) async {
    var params = Map<String, String>();
    params["Authorization"] = ":Bearer " + tk;
    var body = Map<String, String>();
    body['password'] = password.toString();
    var client = http.Client();
    print("body" + body.toString());
    var uri = Uri.https(url, '/app/api/member/user/revoke');
    var response = await client.post(uri, body: body, headers: params);
    print("here" + response.body);
    return (response.body);
  }
}
