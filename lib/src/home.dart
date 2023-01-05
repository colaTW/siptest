import 'dart:convert';

import 'package:dart_sip_ua_example/src/bulletin.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../notification.dart';
import 'APIs.dart';
import 'gobalinfo.dart';
import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'message.dart';
import 'dialpad.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

TextEditingController DomainIP = new TextEditingController();
String username="";
List<dynamic> upimg = [];

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeWidget();
  }
}

class _HomeWidget extends State<HomeWidget> {
  @override
  void initState() {
    getbanner();
  }

  final Map<String, String> _wsExtraHeaders = {
    // 'Origin': ' https://tryit.jssip.net',
    // 'Host': 'tryit.jssip.net:10443'
  };
  final SIPUAHelper _helper = SIPUAHelper();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: Color(0xffE6E1E0),
        appBar: AppBar(
          leadingWidth: 20, //<-- Use this

          centerTitle: false,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          title: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child:Image.asset('assets/images/logo.png',)),
          actions: [
            Padding(padding: EdgeInsets.fromLTRB(50, 10, 0, 10),
           child:IconButton(
              icon: Image.asset('assets/images/P1.png'),
              iconSize: 150,
              onPressed:(){
                Navigator.pushNamed(context, '/bind');

              }
          )),
          ],
          backgroundColor:Color(0xffE6E1E0) ,
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color:Colors.white,
                padding:const EdgeInsets.all(10) ,
                width:width-10,
                height: 250,
                child:
                upimg.length==0?Text(''):new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      child: Image.network(upimg[index]['image'],fit:BoxFit.fitWidth,),
                    );
                  },
                  itemCount: upimg.length,
                  loop: true,
                  autoplay: true,
                  pagination:
                  new SwiperPagination(alignment: Alignment.bottomCenter,margin: EdgeInsets.all(0)),
                  control: new SwiperControl(),//如果不填則不顯示指示點 control: new SwiperControl(),//如果不填則不顯示左右按鈕 ), ),
                )
            ),
            //1Row
            Container(
              height: height/2,
                child:SingleChildScrollView(
          child:Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                child:Image.asset('assets/images/P5.png',fit:BoxFit.cover),
                onTap: (){
                  Navigator.pushNamed(context, '/');
                },
              ),),
            Expanded(
              child: GestureDetector(
                child:Image.asset('assets/images/P6.png',fit:BoxFit.cover),
                onTap: (){
                  Navigator.pushNamed(context, '/security');
                },
              ),),
            Expanded(
              child: GestureDetector(
                child:Image.asset('assets/images/P7.png',fit:BoxFit.cover),
                onTap: (){
                  Navigator.pushNamed(context, '/message');
                },
              ),),
          ],
        ),
        //2ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                child:Image.asset('assets/images/P8.png',fit:BoxFit.cover),
                onTap: (){
                  Navigator.pushNamed(context, '/bulletin');
                },
              ),),
            SizedBox(width: width/3,),
            SizedBox(width: width/3,),

            /*Expanded(
                  child: GestureDetector(
                    child:Image.asset('assets/images/P9.png',fit:BoxFit.cover),
                    onTap: (){
                    },
                  ),),
                Expanded(
                  child: GestureDetector(
                    child:Image.asset('assets/images/P10.png',fit:BoxFit.cover),
                    onTap: (){
                    },
                  ),),*/

          ],
        ),
        //3Row
        /*  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    child:Image.asset('assets/images/P11.png',fit:BoxFit.cover),
                    onTap: (){
                    },
                  ),),
                Expanded(
                  child: GestureDetector(
                    child:Image.asset('assets/images/P12.png',fit:BoxFit.cover),
                    onTap: (){
                    },
                  ),),
                Expanded(
                  child: GestureDetector(
                    child:Image.asset('assets/images/P13.png',fit:BoxFit.cover),
                    onTap: (){
                    },
                  ),),

              ],
            ),*/


      ],))),

            Container(
              padding: EdgeInsets.all(8.0),
              color: Color(0xff758AFC),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Expanded(
                    child:
                   GestureDetector(
                      child:
                      Image.asset('assets/images/P14.png',),
                      onTap: (){
                      },
                    ),),
                  Image.asset('assets/images/P17.png',),
                  Expanded(
                    child: GestureDetector(
                      child:Image.asset('assets/images/P15.png',),
                      onTap: (){
                        _launchInBrowser(Uri.parse("http://www.reddotsolution.com/home/index-5.html"));

                      },
                    ),),
                  Image.asset('assets/images/P17.png',),
                  Expanded(
                    child: GestureDetector(
                      child:Image.asset('assets/images/P16.png',),
                      onTap: (){
                        _launchInBrowser(Uri.parse("http://www.reddotsolution.com/home/index-5.html"));
                      },
                    ),),
                ],
              ),)
          ],
        ),
        );
  }
getbanner() async{
    upimg.clear();
  var re=json.decode(await APIs().getbanner());
  if(re['data'].length==0){
    return;
  }
  for(int i=0;i<re['data'].length;i++){
    if(re['data'][i]['area']==1){
      if(re['data'][i]['imageUrl']==''){re['data'][i]['imageUrl']='https://baotai.com.tw/baotai/img/index1.png';}
      setState(() {
        upimg.add({'image':re['data'][i]['imageUrl'],'url':re['data'][i]['url']});
      });
    }
  }
  print(upimg.toString());
}
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}

