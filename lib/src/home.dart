import 'package:dart_sip_ua_example/src/bulletin.dart';
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
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    DomainIP.text= await prefs.getString("DomainIP")??"";
                    username=await prefs.getString("username")??"";
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>sipphone(data:{"username":username,"DomainIP":DomainIP.text})));
                  },
                    onLongPress:() async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      DomainIP.text= await prefs.getString("DomainIP")??"";
                      showAlertDialog(context);
                                          }
                ),
                IconButton(
                  icon: Image.asset('assets/images/message.png'),
                  iconSize: 150,
                  onPressed: () {

                    Navigator.push(context,MaterialPageRoute(builder: (context) =>message()));

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
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>bulletin()));

                  },
                ),
                IconButton(
                  icon: Image.asset('assets/images/mailbox.png'),
                  iconSize: 150,
                  onPressed: () {
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

