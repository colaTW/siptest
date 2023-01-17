import 'dart:convert';

import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:sip_ua/sip_ua.dart';

import 'APIs.dart';

class bulletinlist extends StatefulWidget {
  dynamic info;
  dynamic profile;
  bulletinlist(this.info, this.profile, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _bulletinlist();
  }
}
class _bulletinlist extends State<bulletinlist> {
  var myhouses=null;
  var chiocehouse;
  var bulletinlistdata=[];
  var nowpage=1;
  var totalpage=3;
  var nowbulletin=1;
  var isloading=false;

  @override
  void initState() {
   myhouses=widget.profile['houses'];
   getbulltinlist(widget.profile['houses'][0]['constructionId'],"1");
   chiocehouse=widget.profile['houses'][0];
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        backgroundColor: Color(0xffE6E1E0),
        appBar: new AppBar(
            title: new Text("社區公告"),
            backgroundColor:Color(0xffE6E1E0) ,
        ),
        body: Column(children: [
          Row(children: [
            Text("住戶:"),
            new Expanded(child:
            new Container(color:Colors.white,
              child:new DropdownButtonHideUnderline(child:
              new DropdownButton<dynamic>(
                isExpanded: true,
                hint:Center(child: Text('－－請選擇住戶－－',textAlign: TextAlign.center)),
                items:myhouses.map<DropdownMenuItem<dynamic>>((item) {
                  return new DropdownMenuItem<dynamic>(
                    child: Center(child:new Text(item['constructionName']+item['houseName'])),
                    value: item,
                  );
                }).toList(),
                onChanged: (selectvalue) {
                  setState(() {
                    chiocehouse=selectvalue;
                    print(chiocehouse['constructionId'].toString());
                    getbulltinlist(chiocehouse['constructionId'], nowpage);
                  });
                },
                value: chiocehouse,
              )),)),
            SizedBox(width: 10,)
          ],),
          SingleChildScrollView(
            child: new ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bulletinlistdata.length == 0 ? 0 : bulletinlistdata.length,
              itemBuilder: (BuildContext context, int index){
                return new Card(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: new Text(bulletinlistdata[index]['bulletinTitle'],softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 2,),),
                        Flexible(child: new Text(bulletinlistdata[index]['bulletinContent'],softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 2,),),
                        ElevatedButton(onPressed: (){
                             nowbulletin=index;
                             showBulltinDialog(context);
                        }, child: Text("詳細內容..."))
                      ], )
                );
              },
            ),
           ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            isloading?Center(child: CircularProgressIndicator(),)
                :ElevatedButton(onPressed:nowpage==1?null:(){
            setState(() {
            nowpage--;
            isloading=true;
            getbulltinlist(chiocehouse['constructionId'], nowpage);
            });
            }, child: Text("<")),
            Text(nowpage.toString()+"/"+totalpage.toString()),
            isloading?Center(child: CircularProgressIndicator(),)
                :ElevatedButton(onPressed:nowpage==totalpage?null:(){
            setState(() {
            nowpage++;
            isloading=true;
            getbulltinlist(chiocehouse['constructionId'], nowpage);

            });
            }, child: Text(">")),]),

    ],)
    );
  }
  void getbulltinlist(var constructionId,var page) async{
    var re = json.decode(await APIs().getbulltinlist_member(widget.info['token'],"",constructionId,page ));

    setState(() {
      bulletinlistdata=re['lists'];
      isloading=false;
      totalpage=re['items']['last_page'];
      print(bulletinlistdata.toString());

    });

  }
  void showBulltinDialog(BuildContext context) {
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
                height:height ,
                child:
                SingleChildScrollView(
                    child:
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                          child: Text(bulletinlistdata[nowbulletin]['bulletinTitle']),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                          child: Text(bulletinlistdata[nowbulletin]['bulletinContent']),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(onPressed:nowbulletin==0?null:(){
                              setState(() {
                                nowbulletin--;
                                Navigator.pop(context);
                                showBulltinDialog(context);
                              });
                            }, child: Text("上一則")),
                            bulletinlistdata[nowbulletin]["images"].length==0?Text("") : Expanded(child:Image.network(bulletinlistdata[nowbulletin]["images"][0]),),
                            ElevatedButton(onPressed:nowbulletin==bulletinlistdata.le?null:(){
                              setState(() {
                                nowbulletin++;
                                Navigator.pop(context);
                                showBulltinDialog(context);
                              });
                            }, child: Text("下一則")),


                          ],)
                      ],))
            ),
          );
        });
  }
}


