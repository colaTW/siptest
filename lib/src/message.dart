import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_ua/sip_ua.dart';

class message extends StatefulWidget {
  dynamic info;
  message(this.info,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _message();
  }
}
class _message extends State<message> {
  final Map<String, String> _wsExtraHeaders = {
    // 'Origin': ' https://tryit.jssip.net',
    // 'Host': 'tryit.jssip.net:10443'
  };
  TextEditingController fixmessage = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("取得"+widget.info.toString());
    return Scaffold(
      backgroundColor: Color(0xffE6E1E0),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
          title: Text('住戶報修/列表'),
        backgroundColor:Color(0xffE6E1E0) ,

      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: ElevatedButton(child:Text("意見回饋") ,onPressed: (){
                    Navigator.pushNamed(context, '/messagefix');
                  },)
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: ElevatedButton(child:Text("我的意見列表") ,onPressed: (){
                    Navigator.pushNamed(context, '/messagelist');
                  },)
              ),
            ],)

          ],
        ),
        );
  }

}
