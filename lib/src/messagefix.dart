import 'dart:convert';

import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scan/scan.dart';
import 'package:sip_ua/sip_ua.dart';

import 'APIs.dart';

class messagefix extends StatefulWidget {
  dynamic info;
  messagefix(this.info,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _messagefix();
  }
}
class _messagefix extends State<messagefix> {
  var img1Path,img2Path,img3Path,img4Path,img5Path;
  var img1id,img2id,img3id,img4id,img5id;
  var residentID;
  String camera='assets/images/cream.png';
  String upfile='assets/images/flieupload.png';
  TextEditingController fixmessage = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("fix"+widget.info.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text('住戶報修'),
        ),
        body: SingleChildScrollView(
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text("報修事項: 維修"),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                controller: fixmessage,
                minLines: 10,
                maxLines: 15,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.message),
                  labelText: "報修詳細描述",
                  hintText: "ex:浴室水龍頭漏水",
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(child: IconButton(icon:Image.asset(camera),onPressed: _takePhoto,iconSize:100,)),
                Expanded(child: IconButton(icon:Image.asset(upfile),onPressed: _openGallery,iconSize:100)),
              ],
            ),
            Scrollbar(
                child:
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //img1Path==null?Text(''): Image.network(img1Path,height:75,width:75,fit: BoxFit.fill,),
                        img1Path==null?Text(''): Image.memory(base64Decode(img1Path),height:75,width:75,fit: BoxFit.fill,),
                        img1Path==null? Text(''):GestureDetector(onTap:(){ setState(() {img1Path = null;});} ,
                            child: Image.network('https://i.kfs.io/album/tw/166074,0v3/fit/500x500.jpg',fit:BoxFit.cover,width: 20,height: 20,)),
                        SizedBox(width: 50,),
                        img2Path==null?Text(''): Image.network(img2Path,height:75,width:75,fit: BoxFit.fill),
                        img2Path==null? Text(''):GestureDetector(onTap:(){ setState(() {img2Path = null;});} ,
                            child: Image.network('https://i.kfs.io/album/tw/166074,0v3/fit/500x500.jpg',fit:BoxFit.cover,width: 20,height: 20,)),
                        SizedBox(width: 50,),
                        img3Path==null?Text(''): Image.network(img3Path,height:75,width:75,fit: BoxFit.fill),
                        img3Path==null? Text(''):GestureDetector(onTap:(){ setState(() {img3Path = null;});} ,
                            child: Image.network('https://i.kfs.io/album/tw/166074,0v3/fit/500x500.jpg',fit:BoxFit.cover,width: 20,height: 20,)),
                        SizedBox(width: 50,),
                        img4Path==null?Text(''): Image.network(img4Path,height:75,width:75,fit: BoxFit.fill),
                        img4Path==null? Text(''):GestureDetector(onTap:(){ setState(() {img4Path = null;});} ,
                            child: Image.network('https://i.kfs.io/album/tw/166074,0v3/fit/500x500.jpg',fit:BoxFit.cover,width: 20,height: 20,)),
                        SizedBox(width: 50,),
                        img5Path==null?Text(''): Image.network(img5Path,height:75,width:75,fit: BoxFit.fill),
                        img5Path==null? Text(''):GestureDetector(onTap:(){ setState(() {img5Path = null;});} ,
                            child: Image.network('https://i.kfs.io/album/tw/166074,0v3/fit/500x500.jpg',fit:BoxFit.cover,width: 20,height: 20,)),
                      ]
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton(onPressed: (){
                sentfix();

              }, child: Text("送出"))
            ],)



          ],
        ),
        ));
  }
  _takePhoto() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          camera = 'assets/images/cupertino.gif';
        });
        var name = image.toString().split('/');
        var filename = name[name.length - 1];
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        setState(() {
          img1Path=base64Image;
          camera = 'assets/images/cream.png';
        });

        var re = json.decode(await APIs().uploadimg_project(widget.info['token'],base64Image, filename));
        if (img1Path == null) {
          if (re['code'] == 0) {
            img1id = re['projectFileId'].toString();
            setState(() {
              img1Path = re['projectFileUrl'];
              camera = 'assets/images/mainten_create/cream.png';
            });
          }
        }
        else if (img2Path == null) {
          if (re['code'] == 0) {
            img2id = re['projectFileId'].toString();
            setState(() {
              img2Path = re['projectFileUrl'];
              camera = 'assets/images/mainten_create/cream.png';
            });
          }
        }
        else if (img3Path == null) {
          if (re['code'] == 0) {
            img3id = re['projectFileId'].toString();
            setState(() {
              img3Path = re['projectFileUrl'];
              camera = 'assets/images/mainten_create/cream.png';
            });
          }
        }
        else if (img4Path == null) {
          if (re['code'] == 0) {
            img4id = re['projectFileId'].toString();
            setState(() {
              img4Path = re['projectFileUrl'];
              camera = 'assets/images/mainten_create/cream.png';
            });
          }
        } else if (img5Path == null) {
          if (re['code'] == 0) {
            img5id = re['projectFileId'].toString();
            setState(() {
              img5Path = re['projectFileUrl'];
              camera = 'assets/images/mainten_create/cream.png';
            });
          }
        }
        else {
          setState(() {
            camera = 'assets/images/mainten_create/cream.png';
          });
          Fluttertoast.showToast(
              msg: '照片以五張為限',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Colors.black,
              fontSize: 16.0
          );        }

    }
  }
  /*相册*/
  _openGallery() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          upfile = 'assets/images/cupertino.gif';
        });
        var name = image.toString().split('/');
        var filename = name[name.length - 1];
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        setState(() {
          img1Path=base64Image;
          upfile = 'assets/images/flieupload.png';
        });

        var re = json.decode(await APIs().uploadimg_project(widget.info['token'],base64Image, filename));
        print(re);
        if (img1Path == null) {
          if (re['code'] == 0) {
            img1id = re['projectFileId'].toString();
            setState(() {
              img1Path = re['projectFileUrl'];
              upfile = 'assets/images/mainten_create/flieupload.png';
            });
          }
        }
        else if (img2Path == null) {
          if (re['code'] == 0) {
            img2id = re['projectFileId'].toString();
            setState(() {
              img2Path = re['projectFileUrl'];
              upfile = 'assets/images/mainten_create/flieupload.png';
            });
          }
        }
        else if (img3Path == null) {
          if (re['code'] == 0) {
            img3id = re['projectFileId'].toString();
            setState(() {
              img3Path = re['projectFileUrl'];
              upfile = 'assets/images/mainten_create/flieupload.png';
            });
          }
        }
        else if (img4Path == null) {
          if (re['code'] == 0) {
            img4id = re['projectFileId'].toString();
            setState(() {
              img4Path = re['projectFileUrl'];
              upfile = 'assets/images/mainten_create/flieupload.png';
            });
          }
        }
        else if (img5Path == null) {
          if (re['code'] == 0) {
            img5id = re['projectFileId'].toString();
            setState(() {
              img5Path = re['projectFileUrl'];
              upfile = 'assets/images/mainten_create/flieupload.png';
            });
          }
        }
        else {
          Fluttertoast.showToast(
              msg: '照片以5張為限',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              backgroundColor: Colors.black,
              fontSize: 16.0
          );
          setState(() {
            upfile = 'assets/images/mainten_create/flieupload.png';
          });
        }
    }
  }
  sentfix()async{

      var info = Map<String, dynamic>();
      info['projectCategoryId'] = "1";
      info['projectItemId'] = "1";
      info['name']="test0821";
      info['phone']="0952689610";
      info['mobile']="0952689610";
      info['email']="cola556601@gmail";
      info['address']="test" ;
      info['building']=""  ;
      info['household']="1";
      info['floor']="1";
      info['message'] = fixmessage.text.toString();
      List<dynamic> images=[];
      if(img1id!=null)images.add(img1id);
      if(img2id!=null)images.add(img2id);
      if(img3id!=null)images.add(img3id);
      if(img4id!=null)images.add(img4id);
      if(img5id!=null)images.add(img5id);
      info['images'] = images;
      info['files'] = [];


      var end = json.decode(await APIs().menberfix(widget.info['token'], info));

      if (end['code'] == 0) {
        Alert(
            title: '結果',
            context: context,
            type: AlertType.success,
            desc: "成功",
            buttons: [
              DialogButton(onPressed: (){
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pop(context);

              }, child: Text('確認'))
            ]
        ).show();
      }
      else {
        Alert(
            title: '失敗',
            context: context,
            type: AlertType.error,
            desc: end['message'],

        ).show();      }

  }
}
