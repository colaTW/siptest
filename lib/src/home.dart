import 'dart:convert';

import 'package:dart_sip_ua_example/src/bulletin.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
String username = "";
List<dynamic> upimg = [];

class HomeWidget extends StatefulWidget {
  dynamic isBind;
  dynamic profile;
  HomeWidget(this.isBind, this.profile, {Key? key}) : super(key: key);
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
    print(widget.profile['houses']);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: Color(0xffE6E1E0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 30,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            )),
        actions: [
          Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 0, 10),
              child: IconButton(
                  icon: Image.asset('assets/images/P1.png'),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.pushNamed(context, '/bind');
                  })),
        ],
        backgroundColor: Color(0xffE6E1E0),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              width: width - 10,
              height: 250,
              child: upimg.length == 0
                  ? Text('')
                  : new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: Image.network(
                            upimg[index]['image'],
                            fit: BoxFit.fitWidth,
                          ),
                        );
                      },
                      itemCount: upimg.length,
                      loop: true,
                      autoplay: true,
                      pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.all(0)),
                      control:
                          new SwiperControl(), //如果不填則不顯示指示點 control: new SwiperControl(),//如果不填則不顯示左右按鈕 ), ),
                    )),
          //1Row
          Container(
              height: height / 2,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Image.asset('assets/images/P5.png',
                              fit: BoxFit.cover),
                          onTap: () {
                            if (!widget.isBind) {
                              Fluttertoast.showToast(
                                  msg: "請先綁定你所屬住戶方可使用",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  fontSize: 16.0);
                              return;
                            }
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Image.asset('assets/images/P6.png',
                              fit: BoxFit.cover),
                          onTap: () {
                            if (!widget.isBind) {
                              Fluttertoast.showToast(
                                  msg: "請先綁定你所屬住戶方可使用",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  fontSize: 16.0);
                              return;
                            }
                            Navigator.pushNamed(context, '/security');
                          },
                        ),
                      ),
                    ],
                  ),
                  //2ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Image.asset('assets/images/P7.png',
                              fit: BoxFit.cover),
                          onTap: () {
                            if (!widget.isBind) {
                              Fluttertoast.showToast(
                                  msg: "請先綁定你所屬住戶方可使用",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  fontSize: 16.0);
                              return;
                            }
                            Navigator.pushNamed(context, '/messagelist');
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Image.asset('assets/images/P8.png',
                              fit: BoxFit.cover),
                          onTap: () {
                            if (!widget.isBind) {
                              Fluttertoast.showToast(
                                  msg: "請先綁定你所屬住戶方可使用",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  fontSize: 16.0);
                              return;
                            }
                            Navigator.pushNamed(context, '/bulletin');
                          },
                        ),
                      ),

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
                ],
              ))),

          Container(
            padding: EdgeInsets.all(8.0),
            color: Color(0xff758AFC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Text(''),
                    onTap: () {
                      showFAQsDialog(context);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Image.asset(
                      'assets/images/P14.png',
                    ),
                    onTap: () {
                      showFAQsDialog(context);
                    },
                  ),
                ),
                Image.asset(
                  'assets/images/P17.png',
                ),
                Expanded(
                  child: GestureDetector(
                    child: Image.asset(
                      'assets/images/P16.png',
                    ),
                    onTap: () {
                      _launchInBrowser(Uri.parse(
                          "http://www.reddotsolution.com/home/index-5.html"));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getbanner() async {
    upimg.clear();
    var re = json.decode(await APIs().getbanner());
    if (re['data'].length == 0) {
      return;
    }
    for (int i = 0; i < re['data'].length; i++) {
      if (re['data'][i]['area'] == 1) {
        if (re['data'][i]['imageUrl'] == '') {
          re['data'][i]['imageUrl'] =
              'https://baotai.com.tw/baotai/img/index1.png';
        }
        setState(() {
          upimg.add({
            'image': re['data'][i]['imageUrl'],
            'url': re['data'][i]['url']
          });
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

void showFAQsDialog(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          backgroundColor: Color(0xffE6E1E0),
          content: Container(
              color: Color(0xffE6E1E0),
              width: width,
              height: height,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/p26.png"),
                  Text(
                    "一、如何開始啟用？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text(
                              "Step1\n至IOS App Store 及Android Play商店下載專屬APP。\nStep2\n首次使用先註冊會員\nStep3\n登入後點右上角「Account」，進行綁定住戶。建案代碼為社區啟用時預設，\n詳情可洽該社區管委會。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n二、出國是否可以使用？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text("可以，只要成功使用internet網絡，異地均能暢通使用。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n三、手機更換或遺失、門號變更，如何重新登入？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text(
                              "手機更換或遺失：重新下載APP輸入當初註冊的帳密即可。\n門號變更：不影響本APP功能，輸入當初註冊的帳密即可。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n四、同住家人可以同時加入嗎？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text("可以的，一戶可以有多人使用。溝通響鈴以同戶優先接通後，同戶其餘響鈴結束。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n五、如何撥打給鄰居？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text(
                              "完成綁定住戶後，登入即可直接撥打給其他住戶。\n於主畫面中按「call 住戶對講」一樣可打給其他住戶，\n比照大樓約定樓層戶別的撥打傳統對講機形式。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n六、如何撥打給警衛？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text(
                              "於主畫面中按「呼叫警衛」立即ㄧ鍵呼叫。\n如使用者名下多戶，則需選擇為哪一戶別的呼叫來源。以利警衛視回應。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n七、如何查詢留言紀錄？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text("於主畫面中按「意見反映」即可得知留言及管委會回覆。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                  Text(
                    "\n八、如何留言？",
                    style: TextStyle(color: Color(0xff7586F8), fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("       "),
                      Flexible(
                          child: Text("於主畫面中按「意見反映」之右上角可新增留言(意見)。",
                              style: TextStyle(
                                  color: Color(0xff3D3D3D), fontSize: 14),
                              textAlign: TextAlign.start)),
                    ],
                  ),
                ],
              ))),
          actions: <Widget>[
            new ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xff7588FA)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("確認"),
            ),
          ],
        );
      });
}
