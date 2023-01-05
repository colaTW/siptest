import 'dart:convert';

import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:sip_ua/sip_ua.dart';

class bindcommunity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _bindcommunity();
  }
}
class _bindcommunity extends State<bindcommunity> {
  var img1Path,img2Path,img3Path,img4Path,img5Path;
  var img1id,img2id,img3id,img4id,img5id;
  var residentID;
  String camera='assets/images/cream.png';
  String upfile='assets/images/flieupload.png';
  TextEditingController fixmessage = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
        backgroundColor: Color(0xffE6E1E0),
        appBar: AppBar(
          backgroundColor: Color(0xffE6E1E0),
          title: Text('使用相機或上傳照片掃描QRcode'),
        ),
        body: Container(
          height: height,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: <Widget>[
                Expanded(child: IconButton(icon:Image.asset(camera),onPressed: _takePhoto,iconSize:100,)),
              ],
            ),
            Row(children: [
              Expanded(child: IconButton(icon:Image.asset(upfile),onPressed: _openGallery,iconSize:100)),

            ],)
          ],
        ),
        ));
  }
  _takePhoto() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      String result = await Scan.parse(image.path)??"";
      print("結局2"+result.toString());
      return;
  }
  /*相册*/
  _openGallery() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      String result = await Scan.parse(image.path)??"";
      print("結局"+result.toString());
      return;
  }
}
