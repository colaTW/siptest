import 'dart:convert';

import 'package:dart_sip_ua_example/src/APIs.dart';
import 'package:dart_sip_ua_example/src/gobalinfo.dart';
import 'package:dart_sip_ua_example/src/registermember.dart';
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
    '/': ([SIPUAHelper? helper, Object? arguments]) => DialPadWidget(helper,""),
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
  bool remeber=false;
  bool isDisable=false;
  @override
  void initState() {
    loadlogininfo();
    super.initState();

  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xffE6E1E0) ,
      appBar: AppBar(
        backgroundColor:Color(0xffE6E1E0) ,
        title: Text("??????"),
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

                labelText: "??????",
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
                labelText: "??????",
                hintText: "Your account password",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: CheckboxListTile(
              title: const Text('????????????????????????'),
              value: remeber,
              onChanged: (bool? value) {
                setState(() {
                  remeber = value!? true:false; // rebuilds with new value
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(onPressed:isDisable?null:()async{
              setState(() {
                isDisable=true;
              });
              String get;
              get = await APIs().login_member(login.text,password.text); //getData()????????????????????????data
              var info = json.decode(get);
              if (info['code'] == 0) {
                if(remeber){
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("username", login.text);
                  await prefs.setString("password", password.text);
                  await prefs.setBool("remeber", remeber);
                }
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString("username", login.text);
                DomainIP.text= await prefs.getString("DomainIP")??"";
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>sipphone(
                        data: {
                          'info': info,
                        })));
              }
              else {
                loginfailDialog(context,info['message']);
              }
              if(mounted){
                setState(() {
                  isDisable=false;
                });
              }


            },

                child: Text('??????')),
              GestureDetector(child:Text("|????????????",style: TextStyle(color: Colors.blue),),onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>registermember()));
              },)
          ],)
        ],
      ),

    );
  }
  showAlertDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: Text("??????IP"),
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        }
    );
  }
  loadlogininfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getlogin=await prefs.getString('username')??"";
    String getpassword=await prefs.getString('password')??"";
    bool getremeber=await prefs.getBool('remeber')??false;

    setState(() {
      login.text= getlogin;
      password.text=getpassword;
      remeber=getremeber;
    });

  }
  void loginfailDialog(BuildContext context,String message) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('????????????:'+message),
            title: Center(
                child: Text(
                  '????????????',
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
                  child: Text('??????')),

            ],
          );
        });
  }
}
// HomePage
