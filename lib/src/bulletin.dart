import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_ua/sip_ua.dart';

class bulletin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _bulletin();
  }
}
class _bulletin extends State<bulletin> {
  @override
  void initState() {

  }
var bulletintext=[];
var imageurl=[];
var nowpage=0;
var totalpage=3;
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        backgroundColor: Color(0xffE6E1E0),
        appBar: new AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
            title: new Text("社區公告",style:TextStyle(color: Color(0xff133B3A)),),
            backgroundColor:Color(0xffE6E1E0) ,),

        body: SingleChildScrollView(
            child:
            Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Text(bulletintext[nowpage]),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed:nowpage==0?null:(){
                      setState(() {
                        nowpage--;
                      });
                    }, child: Text("上一則")),
                    Expanded(child:Image.network(imageurl[nowpage]),),
                    ElevatedButton(onPressed:nowpage==totalpage?null:(){
                      setState(() {
                        nowpage++;

                      });
                    }, child: Text("下一則")),


                  ],)
            ],))

    );
  }
}


