import 'package:dart_sip_ua_example/src/gobalinfo.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sip_ua/sip_ua.dart';

import 'src/about.dart';
import 'src/callscreen.dart';
import 'src/dialpad.dart';
import 'src/register.dart';
import 'src/sipphone.dart';
import 'src/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
TextEditingController DomainIP = new TextEditingController();

void main() {
  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MyApp());
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final SIPUAHelper _helper = SIPUAHelper();
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
            home: HomePage(),
          );
        }
      },
    );
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
class HomePage extends StatelessWidget {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("首頁"),
        ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              controller:login,
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
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),

                labelText: "密碼",
                hintText: "Your account password",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(onPressed:()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString("username", login.text);
              DomainIP.text= await prefs.getString("DomainIP")??"";

              Navigator.push(context,MaterialPageRoute(builder: (context) =>sipphone(data:{"username":login.text,"DomainIP":DomainIP.text})));

            },
                onLongPress: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  DomainIP.text= await prefs.getString("DomainIP")??"";

                  showAlertDialog(context);
                },
                child: Text('登入'))
          ],)
        ],
      ),

    );
  }
  showAlertDialog(BuildContext context) {
    // Init

    AlertDialog dialog = AlertDialog(
      title: Text("設定IP"),
      actions: [
        TextField(
          controller: DomainIP,
          keyboardType: TextInputType.text,
          maxLines: 1,
        ),
        ElevatedButton(
            child: Text("OK"),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString("DomainIP", DomainIP.text);

              Navigator.pop(context);

            }
        ),

      ],
    );

    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        }
    );
  }
}
// HomePage
