import 'dart:convert';

import 'package:dart_sip_ua_example/src/APIs.dart';
import 'package:dart_sip_ua_example/src/bindcommunity.dart';
import 'package:dart_sip_ua_example/src/bulletinlist.dart';
import 'package:dart_sip_ua_example/src/gobalinfo.dart';
import 'package:dart_sip_ua_example/src/login.dart';
import 'package:dart_sip_ua_example/src/message.dart';
import 'package:dart_sip_ua_example/src/messagefix.dart';
import 'package:dart_sip_ua_example/src/messagelist.dart';
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

SIPUAHelper _helper = SIPUAHelper();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  RemoteNotification notification = message.notification as RemoteNotification;
  Map<String, dynamic> params = message.data;
  print("message:" + message.toString());
  print("params:" + params.toString());
  if (params['type'] == "pickUp") {
    showCallkitIncoming(Uuid().v4());

    whoscall = params['fromHouseName'];
    UaSettings settings = UaSettings();
    settings.webSocketUrl = "wss://ip-intercom.reddotsolution.com:4443/ws";
    settings.webSocketSettings.allowBadCertificate = true;
    //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
    settings.uri = params['targetSipName'] + "@ip-intercom.reddotsolution.com";
    settings.authorizationUser = params['targetSipName'];
    settings.password = params['targetSipPassword'];
    settings.displayName = params['targetSipName'];
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    _helper!.start(settings);
  }
}

dynamic info;
dynamic profile;
String gowhere = "/home";

Future<void> showCallkitIncoming(String uuid) async {
  print("showCallkitIncoming:");
  final params = CallKitParams(
    id: uuid,
    nameCaller: whoscall + ' 來電',
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

void main() async {
  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification notification =
        message.notification as RemoteNotification;
    Map<String, dynamic> params = message.data;
    print("message:" + message.toString());
    print("params:" + params.toString());

    if (params['type'] == "pickUp") {
      showCallkitIncoming(Uuid().v4());

      whoscall = params['fromHouseName'];
      //getsipinfo = params;
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
      _helper!.start(settings);
      /*var rng = Random();
      sleep(Duration(milliseconds:rng.nextInt(5)*100));
      var get = await APIs().answercall(widget.info['token'],
          getsipinfo['fromId'], getsipinfo['targetSipId'],params['fromType']);
      var respone = json.decode(get);
      print("colarespone" + respone.toString());*/
    }
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
  await loadinfo();
  runApp(MyApp());
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper? helper, Object? arguments]) =>
        DialPadWidget(helper, "", profile, info),
    '/register': ([SIPUAHelper? helper, Object? arguments]) =>
        RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper? helper, Object? arguments]) =>
        CallScreenWidget(helper, arguments as Call?),
    '/about': ([SIPUAHelper? helper, Object? arguments]) => AboutWidget(),
    '/home': ([SIPUAHelper? helper, Object? arguments]) =>
        HomeWidget(isBind, profile),
    '/message': ([SIPUAHelper? helper, Object? arguments]) => message(info),
    '/bulletin': ([SIPUAHelper? helper, Object? arguments]) =>
        bulletinlist(info, profile),
    '/messagefix': ([SIPUAHelper? helper, Object? arguments]) =>
        messagefix(info),
    '/messagelist': ([SIPUAHelper? helper, Object? arguments]) => messagelist(
          info,
        ),
    '/security': ([SIPUAHelper? helper, Object? arguments]) =>
        DialPadWidget(helper, "1", profile, info),
    '/bind': ([SIPUAHelper? helper, Object? arguments]) =>
        bindcommunity(info, profile),
    '/login': ([SIPUAHelper? helper, Object? arguments]) => Login(),
  };

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final PageContentBuilder? pageContentBuilder = routes[name!];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) =>
                pageContentBuilder(_helper, settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) => pageContentBuilder(_helper));
        return route;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("gowhere:" + gowhere);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: gowhere,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

loadinfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getlogin = await prefs.getString('username') ?? "";
  String getpassword = await prefs.getString('password') ?? "";
  bool getremeber = await prefs.getBool('remeber') ?? false;
  String gettoken = await prefs.getString('token') ?? "0123";
  print("oo" + gettoken);
  var re = json.decode(await APIs().getmemberprofile(gettoken));
  if (re['code'] == 0) {
    var info2 = json.decode('{"token":"' + gettoken + '"}');
    info = info2;
    profile = re['data'];
    if (profile['houses'].length > 0) {
      print(">0");
      isBind = true;
      gowhere = "/";
    } else {
      print("<0");

      gowhere = "/home";

      isBind = false;
    }
    return;
  } else {
    gowhere = "/login";
    Fluttertoast.showToast(
        msg: '登入超時請重新登入',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 16.0);
  }
}
