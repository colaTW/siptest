import 'package:dart_sip_ua_example/src/bulletin.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../notification.dart';
import 'gobalinfo.dart';
import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'message.dart';

TextEditingController DomainIP = new TextEditingController();
String username="";


class HomeWidget extends StatelessWidget {

  final Map<String, String> _wsExtraHeaders = {
    // 'Origin': ' https://tryit.jssip.net',
    // 'Host': 'tryit.jssip.net:10443'
  };
  final SIPUAHelper _helper = SIPUAHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              },
            ),

          title: Text("About"),
        ),
        body: SingleChildScrollView(
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //1Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: IconButton(
                  icon: Image.asset('assets/images/call.png'),
                  iconSize: 150,
                      onPressed:null
                      ),
                  onTap: () async{
                    /*SharedPreferences prefs = await SharedPreferences.getInstance();
                    DomainIP.text= await prefs.getString("DomainIP")??"";
                    username=await prefs.getString("username")??"";
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>sipphone(data:{"username":username,"DomainIP":DomainIP.text})));
                  */
                    Navigator.pushNamed(context, '/');
                  },

                ),
                IconButton(
                  icon: Image.asset('assets/images/message.png'),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.pushNamed(context, '/message');
                  },
                )
              ],
            ),
            //2ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/bull.png'),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.pushNamed(context, '/bulletin');
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/images/mailbox.png'),
                  iconSize: 150,
                  onPressed: () {
                    notification.send("re","test");

                  },
                )
              ],
            ),
            //3Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/cctv.png'),
                  iconSize: 150,
                  onPressed: () {

                  },
                ),
                IconButton(
                  icon: Image.asset('assets/images/security.png'),
                  iconSize: 150,
                  onPressed: () {
                  },
                )
              ],
            ),
          ],
        ),
        ));
  }

}

