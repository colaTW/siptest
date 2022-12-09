import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_ua/sip_ua.dart';

class message extends StatelessWidget {

  final Map<String, String> _wsExtraHeaders = {
    // 'Origin': ' https://tryit.jssip.net',
    // 'Host': 'tryit.jssip.net:10443'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('住戶意見表'),
        ),
        body: SingleChildScrollView(
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "住戶姓名",
                  hintText: "您的大名",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "住戶電話",
                  hintText: "您的電話",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.fiber_new),
                  labelText: "發生位置",
                  hintText: "ex:D棟樓下花園",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                minLines: 10,
                maxLines: 15,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.message),
                  labelText: "改進建議",
                  hintText: "ex:雜草叢生需要修剪",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton(onPressed: (){
                Fluttertoast.showToast(
                    msg: "感謝您的建議，將改進並電話通知。",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 5,
                    textColor: Colors.white,
                    backgroundColor: Colors.black,
                    fontSize: 16.0
                );
                Navigator.of(context).pop('');

              }, child: Text("送出"))
            ],)



          ],
        ),
        ));
  }

}
