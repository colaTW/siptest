import 'dart:convert';

import 'package:dart_sip_ua_example/src/APIs.dart';
import 'package:dart_sip_ua_example/src/gobalinfo.dart';
import 'package:dart_sip_ua_example/src/registermember.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:uuid/uuid.dart';

import 'src/about.dart';
import 'src/callscreen.dart';
import 'src/dialpad.dart';
import 'src/register.dart';
import 'src/sipphone.dart';
import 'src/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController DomainIP = new TextEditingController();
SIPUAHelper _helper = SIPUAHelper();


void main() async {
  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification notification =
    message.notification as RemoteNotification;
    Map<String, dynamic> params = message.data;
    print("message:"+message.toString());
    print("params:" + params.toString());
    showCallkitIncoming(Uuid().v4());

    /* if (params['type'] == "pickUp") {
      whoscall=params['fromHouseName'];
      getsipinfo = params;
      UaSettings settings = UaSettings();
      settings.webSocketUrl = "wss://ip-intercom.reddotsolution.com:4443/ws";
      settings.webSocketSettings.allowBadCertificate = true;
      //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
      settings.uri =
          params['targetSipName'] + "@ip-intercom.reddotsolution.com";
      settings.authorizationUser = params['targetSipName'];
      settings.password = params['targetSipPassword'];
      settings.displayName = params['targetSipName'];
      settings.userAgent = 'Dart SIP Client v1.0.0';
      settings.dtmfMode = DtmfMode.RFC2833;
      print("setting:" + settings.webSocketUrl.toString());
      helper!.start(settings);
      var rng = Random();
      sleep(Duration(milliseconds:rng.nextInt(5)*100));
      var get = await APIs().answercall(widget.info['token'],
          getsipinfo['fromId'], getsipinfo['targetSipId'],params['fromType']);
      var respone = json.decode(get);
      print("colarespone" + respone.toString());
    }*/


  });
  _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(MyApp());
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: SplashPage(),
          );
        }

        // Main
        else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        }
      },
    );
  }
  Future<void> showCallkitIncoming(String uuid) async {
    final params = CallKitParams(
      id: uuid,
      nameCaller: whoscall+' 來電',
      appName: 'Callkit',
      type: 0,
      duration: 30000,
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);

  }
}

// SplashPage
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: Center(
        child: Icon(
          Icons.phone,
          size: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController buildingcode = TextEditingController();
  bool remeber = false;
  bool isDisable = false;
  @override
  void initState() {
    //loadlogininfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('V1.0.10'),
        onPressed: null,
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),

      ),
      backgroundColor: Color(0xffE6E1E0),
      appBar: AppBar(
        backgroundColor: Color(0xffE6E1E0),
        title: Text("首頁",style:TextStyle(color: Color(0xff133B3A)),),
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
              onChanged: (bool? value) async{
                setState(() {
                  remeber = value! ? true : false; // rebuilds with new value
                });
                SharedPreferences prefs =
                await SharedPreferences.getInstance();

                await prefs.setBool("remeber", remeber);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE6E1E0)
                  ),
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
                            if (remeber) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString("username", login.text);
                              await prefs.setString("password", password.text);
                              await prefs.setBool("remeber", remeber);
                              await prefs.setString("token",info['token']);
                            }
                            get = await APIs().getmemberprofile(info['token']);
                            var profile = json.decode(get);
                            profile=profile['data'];

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => sipphone(data: {
                                          'info': info,
                                          'profile': profile,
                                          'siphelp':_helper
                                        })));
                          } else {
                            loginfailDialog(context, info['message']);
                          }
                          if (mounted) {
                            setState(() {
                              isDisable = false;
                            });
                          }
                        },
                  child: Text('登入',
                  style: TextStyle(color: Color(0xff7587F9)),
                  )),
              Text("  |  ",
                style: TextStyle(color: Color(0xff7587F9)),),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffE6E1E0)
                ),
                child: Text(
                  "註冊會員",
                  style: TextStyle(color: Color(0xff7587F9)),
                ),
                onPressed: isDisable? null
                    : () async{
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
    String gettoken = await prefs.getString('token') ?? "0123";

    var re = json.decode(await APIs().getmemberprofile(gettoken));
    if(true){
      var info2 = json.decode('{"token":"'+gettoken+'"}');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => sipphone(data: {
                'info': info2,
                'profile': re,
                'siphelp':_helper
              })));
      return;
    }
    else{
      Fluttertoast.showToast(
          msg: '登入超時請重新登入',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          backgroundColor: Colors.black,
          fontSize: 16.0
      );
    }

    setState(() {
      remeber = getremeber;
      if(getremeber){
        login.text = getlogin;
        password.text = getpassword;
      }
      else{
        login.text = "";
        password.text = "";
      }
    });
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
}
// HomePage
