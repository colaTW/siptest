import 'dart:convert';

import 'package:dart_sip_ua_example/main.dart';
import 'package:dart_sip_ua_example/src/bulletin.dart';
import 'package:dart_sip_ua_example/src/registermember.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../notification.dart';
import 'APIs.dart';
import 'gobalinfo.dart';
import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'message.dart';
import 'dialpad.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

TextEditingController DomainIP = new TextEditingController();
String username = "";
List<dynamic> upimg = [];

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController buildingcode = TextEditingController();
  bool remeber = false;
  bool isDisable = false;
  @override
  void initState() {
    loadlogininfo();
  }

  final Map<String, String> _wsExtraHeaders = {
    // 'Origin': ' https://tryit.jssip.net',
    // 'Host': 'tryit.jssip.net:10443'
  };
  final SIPUAHelper _helper = SIPUAHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('V1.0.12'),
        onPressed: null,
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
      ),
      backgroundColor: Color(0xffE6E1E0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffE6E1E0),
        title: Text(
          "首頁",
          style: TextStyle(color: Color(0xff133B3A)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              controller: login,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "帳號",
                hintText: "Your account username",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "密碼",
                hintText: "Your account password",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: CheckboxListTile(
              title: const Text('是否記住登入資訊'),
              value: remeber,
              onChanged: (bool? value) async {
                setState(() {
                  remeber = value! ? true : false; // rebuilds with new value
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setBool("remeber", remeber);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE6E1E0)),
                  onPressed: isDisable
                      ? null
                      : () async {
                          setState(() {
                            isDisable = true;
                          });
                          String get;
                          get = await APIs().login_member(login.text,
                              password.text); //getData()延遲執行後賦值給data
                          var info = json.decode(get);
                          if (info['code'] == 0) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (remeber) {
                              await prefs.setString("username", login.text);
                              await prefs.setString("password", password.text);
                              await prefs.setBool("remeber", remeber);
                            }
                            await prefs.setString("token", info['token']);
                            await loadinfo();
                            Navigator.pushNamed(context, '/');

                          } else {
                            loginfailDialog(context, info['message']);
                          }
                          if (mounted) {
                            setState(() {
                              isDisable = false;
                            });
                          }
                        },
                  child: Text(
                    '登入',
                    style: TextStyle(color: Color(0xff7587F9)),
                  )),
              Text(
                "  |  ",
                style: TextStyle(color: Color(0xff7587F9)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffE6E1E0)),
                child: Text(
                  "註冊會員",
                  style: TextStyle(color: Color(0xff7587F9)),
                ),
                onPressed: isDisable
                    ? null
                    : () async {
                        setState(() {
                          isDisable = true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => registermember()));
                        setState(() {
                          isDisable = false;
                        });
                      },
              )
            ],
          )
        ],
      ),
    );
  }

  loadlogininfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getlogin = await prefs.getString('username') ?? "";
    String getpassword = await prefs.getString('password') ?? "";
    bool getremeber = await prefs.getBool('remeber') ?? false;

    setState(() {
      remeber = getremeber;
      if (getremeber) {
        login.text = getlogin;
        password.text = getpassword;
      } else {
        login.text = "";
        password.text = "";
      }
    });
  }
}

void loginfailDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('登入失敗:' + message),
          title: Center(
              child: Text(
            '登入訊息',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          )),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('确定')),
          ],
        );
      });
}
