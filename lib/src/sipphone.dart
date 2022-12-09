import 'package:dart_sip_ua_example/src/gobalinfo.dart';
import 'package:dart_sip_ua_example/src/home.dart';
import 'package:flutter/foundation.dart'
show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'about.dart';
import 'callscreen.dart';
import 'dialpad.dart';
import 'register.dart';
String getDomainIP="";
String username="";


typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);

// ignore: must_be_immutable
class sipphone extends StatelessWidget {
  dynamic data;
  sipphone({this.data});
   SIPUAHelper _helper = SIPUAHelper();
  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper? helper, Object? arguments]) => DialPadWidget(helper),
    '/register': ([SIPUAHelper? helper, Object? arguments]) =>
        RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper? helper, Object? arguments]) =>
        CallScreenWidget(helper, arguments as Call?),
    '/about': ([SIPUAHelper? helper, Object? arguments]) => AboutWidget(),

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
    print('colahere'+data["username"]);
    print('colahere2'+data["DomainIP"]);
    username=data["username"];
    getDomainIP=data["DomainIP"];
     UaSettings settings = UaSettings();
    settings.webSocketUrl = "ws://"+getDomainIP+":8085/ws";
    //"ws://"+getDomainIP+":8080/ws";
    settings.webSocketSettings.allowBadCertificate = true;
    //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
    settings.uri = username+"@"+getDomainIP;
    settings.authorizationUser =username ;
    settings.password =username ;
    settings.displayName =username;
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    print("setting:"+settings.webSocketUrl.toString());
    _helper!.start(settings);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,


    );
  }
   logingsip()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getDomainIP=await prefs.getString("DomainIP")??"";
    username=await prefs.getString("username")??"";
    print("colahere"+getDomainIP);
    print("colahere"+username);


}
}
