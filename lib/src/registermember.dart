import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_ua/sip_ua.dart';
import 'dart:convert';

import 'APIs.dart';


class registermember extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _registermember();
  }
}
class _registermember extends State<registermember> {

  final Map<String, String> _wsExtraHeaders = {
    // 'Origin': ' https://tryit.jssip.net',
    // 'Host': 'tryit.jssip.net:10443'
  };
  TextEditingController fixmessage = new TextEditingController();
  var isDisable=false;
  TextEditingController account = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController checkpassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController phone = TextEditingController();
  var buildID="1";
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var notify_token="";
  @override
  initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token){
      notify_token=token.toString();
      print("token"+token.toString());});
    _firebaseMessaging.subscribeToTopic('all');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6E1E0),

      appBar: AppBar(
          title: Text('會員註冊',style:TextStyle(color: Color(0xff133B3A))),
        backgroundColor:Color(0xffE6E1E0) ,

      ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller:name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "名稱",
                    hintText: "Your account username",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller:account,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "帳號",
                    hintText: "Your account",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller:password,
                  obscureText:  true,
                  decoration:  InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "密碼",
                    hintText: "Your account password",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller:checkpassword,
                  obscureText:  true,
                  decoration:  InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "確認密碼",
                    hintText: "Confirm your password",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller:mail,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Email",
                    hintText: "Your account Email",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                  controller:phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "電話",
                    hintText: "Your phone number",
                  ),
                ),
              ),

              SizedBox(
                height: 52.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 48.0,
                height: 48.0,
                child: ElevatedButton(
                  child: Text("註冊"),
                  onPressed: isDisable?null:()
                  async{
                      String get;
                      get = await APIs().register_member(buildID,name.text,account.text,password.text,checkpassword.text,phone.text,mail.text,notify_token); //getData()延遲執行後賦值給data
                      var info = json.decode(get);
                      if(info['code']!=0){
                        Fluttertoast.showToast(
                            msg: info['message'],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.black,
                            fontSize: 16.0
                        );
                        return;
                      }
                      //success
                      Navigator.of(context).pop();
                      registerSuccesssDialog(context);

                  }
                  ,
                ),
              ),
            ],
          ),
        ),
        );
  }
  void registerSuccesssDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('註冊成功'),
            title: Center(
                child: Text(
                  '註冊狀態',
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
