import 'dart:convert';

import 'package:dart_sip_ua_example/main.dart';
import 'package:dart_sip_ua_example/src/login.dart';
import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

import 'APIs.dart';

class bindcommunity extends StatefulWidget {
  dynamic info;
  dynamic profile;
  bindcommunity(this.info, this.profile, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _bindcommunity();
  }
}

class _bindcommunity extends State<bindcommunity> {
  var img1Path, img2Path, img3Path, img4Path, img5Path;
  var img1id, img2id, img3id, img4id, img5id;
  var residentID;
  String camera = 'assets/images/cream.png';
  String upfile = 'assets/images/flieupload.png';
  TextEditingController constructionCode = new TextEditingController();
  TextEditingController password = new TextEditingController();

  var houseinfo = null;
  var houseID;
  var constructionName = "";
  @override
  Widget build(BuildContext context) {
    print(widget.info.toString());
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          child: Text(APIs().version),
          onPressed: null,
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
        ),
        backgroundColor: Color(0xffE6E1E0),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xffE6E1E0),
          title: Text(
            '帳號管理',
            style: TextStyle(color: Color(0xff133B3A)),
          ),
          actions: [],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: constructionCode,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "建案代碼",
                        hintText: "Your constructionsID",
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE6E1E0)),
                      onPressed: () async {
                        String get;
                        get = await APIs().getconstructioninfo(
                            constructionCode.text.toString());
                        var info = json.decode(get);
                        print(info.length.toString());
                        if (info['code'] != 0) {
                          return;
                        }
                        info = info['data'];
                        if (info.length == 0) {
                          Fluttertoast.showToast(
                              msg: "查無此建案",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              backgroundColor: Colors.black,
                              fontSize: 16.0);
                          setState(() {
                            houseinfo = null;
                          });
                        } else {
                          setState(() {
                            houseinfo = info['houses'];
                            constructionName = info['constructionName'];
                          });
                        }
                      },
                      child: Text(
                        "搜尋",
                        style: TextStyle(color: Color(0xff7587F9)),
                      ))
                ],
              ),
              houseinfo == null
                  ? Text("")
                  : Row(
                      children: [
                        Text(constructionName),
                        Expanded(
                          child: DropdownButton<dynamic>(
                            isExpanded: true,
                            hint: Center(
                                child:
                                    Text('請選擇住戶', textAlign: TextAlign.center)),
                            items: houseinfo
                                .map<DropdownMenuItem<dynamic>>((item) {
                              return new DropdownMenuItem<dynamic>(
                                child:
                                    Center(child: new Text(item['houseName'])),
                                value: item['houseID'],
                              );
                            }).toList(),
                            onChanged: (selectvalue) {
                              print(selectvalue);
                              setState(() {
                                houseID = selectvalue;
                              });
                            },
                            value: houseID,
                          ),
                        ),
                      ],
                    ),

              /*Row(
              children: <Widget>[
                Expanded(child: IconButton(icon:Image.asset(camera),onPressed: _takePhoto,iconSize:100,)),
              ],
            ),
            Row(children: [
              Expanded(child: IconButton(icon:Image.asset(upfile),onPressed: _openGallery,iconSize:100)),
            ],),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE6E1E0)),
                      onPressed: () async {
                        String get;
                        get = await APIs().bindcommunity(widget.info['token'],
                            houseID.toString()); //getData()延遲執行後賦值給data
                        var info = json.decode(get);
                        if (info['code'] == 0) {
                          Fluttertoast.showToast(
                              msg: '綁定成功，請重新登入',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              backgroundColor: Colors.black,
                              fontSize: 16.0);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("token", '123');

                          Navigator.pushNamed(context, '/login');
                        } else {
                          Fluttertoast.showToast(
                              msg: info['message'],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              backgroundColor: Colors.black,
                              fontSize: 16.0);
                        }
                      },
                      child: Text(
                        "　確定　",
                        style: TextStyle(color: Color(0xff7587F9)),
                      ))
                ],
              ),
              Container(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0)),
                  )),
              SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text('登入帳號：' +
                          profile['memberName'] +
                          "(" +
                          profile['memberAccount'] +
                          ")")
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("已綁定的住戶:"),
                      )
                    ],
                  ),
                  new ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.profile['houses'].length == 0
                        ? 0
                        : widget.profile['houses'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                          child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: new Text(
                                widget.profile['houses'][index]
                                        ['constructionName'] +
                                    widget.profile['houses'][index]
                                        ['houseName'],
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                textAlign: TextAlign.left),
                          ),

                          /*Container(child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff7588FA)),
                                  onPressed: (){
                                  }, child: Text("解除綁定")),) */
                        ],
                      ));
                    },
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffE6E1E0)
                    ),
                    onPressed: (){
                      deleteaccountDialog(context);
                    }, child:Text ("電話簿",
                  style: TextStyle(color: Color(0xff7587F9)),)),*/
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE6E1E0)),
                      onPressed: () {
                        deleteaccountDialog(context);
                      },
                      child: Text(
                        "刪除帳戶",
                        style: TextStyle(color: Color(0xff7587F9)),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE6E1E0)),
                      onPressed: () async {
                        var re = json.decode(await APIs()
                            .getmemberprofile(widget.info['token']));
                        if (re['code'] == 0) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("token", '123');

                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      child: Text(
                        "登出帳號",
                        style: TextStyle(color: Color(0xff7587F9)),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE6E1E0)),
                      onPressed: () async {
                        var notify_token;
                        FirebaseMessaging _firebaseMessaging =
                            FirebaseMessaging.instance;

                        await _firebaseMessaging.getToken().then((token) {
                          notify_token = token.toString();
                          print("token" + token.toString());
                        });
                        var re = json.decode(await APIs()
                            .updateuuid(widget.info['token'], notify_token));
                        if (re['code'] == 0) {
                          Fluttertoast.showToast(
                              msg: "問題排除成功",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              backgroundColor: Colors.black,
                              fontSize: 16.0);
                        } else {
                          Fluttertoast.showToast(
                              msg: re['message'],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              backgroundColor: Colors.black,
                              fontSize: 16.0);
                        }
                      },
                      child: Text(
                        "來電問題排除",
                        style: TextStyle(color: Color(0xff7587F9)),
                      )),
                ],
              ),
              Text("")
            ],
          ),
        ));
  }

  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    String result = await Scan.parse(image.path) ?? "";
    print("結局2" + result.toString());
    return;
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String result = await Scan.parse(image.path) ?? "";
    print("結局" + result.toString());
    return;
  }

  void deleteaccountDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: Color(0xffE6E1E0),
            content: Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      child: TextFormField(
                        controller: password,
                        decoration: const InputDecoration(
                          labelText: "密碼",
                          hintText: "Your account password",
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          String get;
                          get = await APIs().deleteaccount(widget.info['token'],
                              password.text.toString()); //getData()延遲執行後賦值給data
                          var info = json.decode(get);
                          if (info['code'] == 0) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString("token", '123');
                            Fluttertoast.showToast(
                                msg: "刪除成功",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                backgroundColor: Colors.black,
                                fontSize: 16.0);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/login');
                          } else {
                            Fluttertoast.showToast(
                                msg: info['message'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                backgroundColor: Colors.black,
                                fontSize: 16.0);
                          }
                        },
                        child: Text("確認刪除"))
                  ],
                )),
          );
        });
  }
}
