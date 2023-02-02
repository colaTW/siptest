import 'package:dart_sip_ua_example/src/bindcommunity.dart';
import 'package:dart_sip_ua_example/src/bulletin.dart';
import 'package:dart_sip_ua_example/src/bulletinlist.dart';
import 'package:dart_sip_ua_example/src/gobalinfo.dart';
import 'package:dart_sip_ua_example/src/home.dart';
import 'package:dart_sip_ua_example/src/message.dart';
import 'package:dart_sip_ua_example/src/messagefix.dart';
import 'package:dart_sip_ua_example/src/messagelist.dart';
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

String getDomainIP = "";
String username = "";
bool isBind = false;

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);
dynamic getdata;
var width;
// ignore: must_be_immutable
class sipphone extends StatefulWidget {
  dynamic data;
  sipphone({this.data});
  @override
  State<StatefulWidget> createState() {
    return _sipphone();
  }
}

class _sipphone extends State<sipphone> {
  String gowhere = "/home";

  @override
  void initState() {
    getdata = widget.data;
  }

  SIPUAHelper _helper = SIPUAHelper();
  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper? helper, Object? arguments]) =>
        DialPadWidget(helper, "", getdata['profile'], getdata['info']),
    '/register': ([SIPUAHelper? helper, Object? arguments]) =>
        RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper? helper, Object? arguments]) =>
        CallScreenWidget(helper, arguments as Call?),
    '/about': ([SIPUAHelper? helper, Object? arguments]) => AboutWidget(),
    '/home': ([SIPUAHelper? helper, Object? arguments]) =>
        HomeWidget(isBind, getdata['profile']),
    '/message': ([SIPUAHelper? helper, Object? arguments]) =>
        message(getdata['info']),
    '/bulletin': ([SIPUAHelper? helper, Object? arguments]) => bulletinlist(getdata['info'],getdata['profile']),
    '/messagefix': ([SIPUAHelper? helper, Object? arguments]) =>
        messagefix(getdata['info']),
    '/messagelist': ([SIPUAHelper? helper, Object? arguments]) =>
        messagelist(getdata['info'],width),
    '/security': ([SIPUAHelper? helper, Object? arguments]) =>
        DialPadWidget(helper, "1", getdata['profile'], getdata['info']),
    '/bind': ([SIPUAHelper? helper, Object? arguments]) =>
        bindcommunity(getdata['info']),
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
    final size = MediaQuery.of(context).size;
    width=size.width;
    if (getdata['profile']['houses'].length > 0) {
      isBind = true;
      gowhere = "/";
    } else {
      isBind = false;
    }

    /*UaSettings settings = UaSettings();
    settings.webSocketUrl = "ws://pingling.asuscomm.com:8080/ws";
    settings.webSocketSettings.allowBadCertificate = true;
    //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
    settings.uri = "0002@pingling.asuscomm.com";
    settings.authorizationUser ="0002" ;
    settings.password ="0002";
    settings.displayName ="0002";
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    print("setting:"+settings.webSocketUrl.toString());
    _helper!.start(settings);*/
    return MaterialApp(
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
