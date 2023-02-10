// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:uuid/uuid.dart';
import '../notification.dart';
import 'APIs.dart';
import 'callscreen.dart';
import 'home.dart';
import 'firebasemessage.dart';
import 'widgets/action_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

TextEditingController DomainIP = new TextEditingController();
dynamic nowwho;
var iscall=0;
SIPUAHelper helper2 = SIPUAHelper();
String whoscall="080";


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  RemoteNotification notification =
  message.notification as RemoteNotification;
  Map<String, dynamic> params = message.data;
  print("message:"+message.toString());
  print("params:" + params.toString());
  if (params['type'] == "pickUp") {
    whoscall=params['fromHouseName'];
    UaSettings settings = UaSettings();
    settings.webSocketUrl = "wss://ip-intercom.reddotsolution.com:4443/ws";
    settings.webSocketSettings.allowBadCertificate = true;
    //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
    settings.uri =
        params['targetSipName'] + "@ip-intercom.reddotsolution.com";
    settings.authorizationUser = params['targetSipName'];
    settings.password = params['targetSipPassword'];
    settings.displayName = params['targetSipName'];
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    helper2!.start(settings);

   }
}


Future<void> showCallkitIncoming(String uuid) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: whoscall+' 來電',
    appName: 'Callkit',
    type: 0,
    duration: 30000,
    textMissedCall: 'Missed call',
    textCallback: 'Call back',
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);

}

class DialPadWidget extends StatefulWidget {
  final SIPUAHelper? _helper;
  final String? get;
  dynamic profile;
  dynamic info;
  DialPadWidget(this._helper, this.get, this.profile, this.info, {Key? key})
      : super(key: key);
  @override
  _MyDialPadWidget createState() => _MyDialPadWidget();
}

class _MyDialPadWidget extends State<DialPadWidget>
    implements SipUaHelperListener {
  String? _dest;
  get helper => widget._helper;
  //get helper=>helper2;
  TextEditingController? _textController;
  late SharedPreferences _preferences;
  String? get get => widget.get;
  String? receivedMsg;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String notify_token = "";
  final List<Message1> messages = [];
  late Map<String, dynamic> getsipinfo;
  @override
  initState() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (get == "1") {
        showchioceDialog(context);
      }
    });
    print( widget.profile['houses'].toString());
    super.initState();
    receivedMsg = "";
    _bindEventListeners();
    _loadSettings();
    print("cola" + get.toString());
    _firebaseMessaging.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification =
          message.notification as RemoteNotification;
      Map<String, dynamic> params = message.data;
      print("message:"+message.toString());
      print("params:" + params.toString());
      if (params['type'] == "pickUp") {
        whoscall=params['fromHouseName'];
        getsipinfo = params;
        UaSettings settings = UaSettings();
        settings.webSocketUrl = "wss://ip-intercom.reddotsolution.com:4443/ws";
        settings.webSocketSettings.allowBadCertificate = true;
        //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
        settings.uri =
            params['targetSipName'] + "@ip-intercom.reddotsolution.com";
        settings.authorizationUser = params['targetSipName'];
        settings.password = params['targetSipPassword'];
        settings.displayName = params['targetSipName'];
        settings.userAgent = 'Dart SIP Client v1.0.0';
        settings.dtmfMode = DtmfMode.RFC2833;
        print("setting:" + settings.webSocketUrl.toString());
        helper!.start(settings);
        var rng = Random();
        sleep(Duration(milliseconds:rng.nextInt(5)*100));
        var get = await APIs().answercall(widget.info['token'],
            getsipinfo['fromId'], getsipinfo['targetSipId'],params['fromType']);
        var respone = json.decode(get);
        print("colarespone" + respone.toString());
      }

      /*UaSettings settings = UaSettings();
    settings.webSocketUrl = "ws://pingling.asuscomm.com:8080/ws";
    settings.webSocketSettings.allowBadCertificate = true;
    //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
    settings.uri = "0003@pingling.asuscomm.com";
    settings.authorizationUser ="0003" ;
    settings.password ="0003" ;
    settings.displayName ="0003";
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    print("setting:"+settings.webSocketUrl.toString());
    helper!.start(settings);*/
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      Navigator.pushNamed(context, '/');

    });




  }

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    _dest = _preferences.getString('dest') ?? '';
    _textController = TextEditingController(text: get);
    _textController!.text = get.toString();
    setState(() {});
  }

  void _bindEventListeners() {
    helper!.addSipUaHelperListener(this);
  }

  Future<Widget?> _handleCall(BuildContext context,
      [bool voiceOnly = false]) async {
    var dest = _textController?.text;
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Permission.microphone.request();
      await Permission.camera.request();
    }
    _textController?.text="";

    if (dest == null || dest.isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Target is empty.'),
            content: Text('Please enter a SIP URI or username!'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }

    final mediaConstraints = <String, dynamic>{'audio': true, 'video': true};

    MediaStream mediaStream;

    if (kIsWeb && !voiceOnly) {
      mediaStream =
          await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = false;
      MediaStream userStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      mediaStream.addTrack(userStream.getAudioTracks()[0], addToNative: true);
    } else {
      mediaConstraints['video'] = !voiceOnly;
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    helper!.call(dest, voiceonly: voiceOnly, mediaStream: mediaStream);
    _preferences.setString('dest', dest);
    return null;
  }

  void _handleBackSpace([bool deleteAll = false]) {
    var text = _textController!.text;
    if (text.isNotEmpty) {
      setState(() {
        text = deleteAll ? '' : text.substring(0, text.length - 1);
        _textController!.text = text;
      });
    }
  }

  void _handleNum(String number) {
    setState(() {
      _textController!.text += number;
    });
  }

  List<Widget> _buildNumPad() {
    var labels = [
      [
        {'1': ''},
        {'2': 'abc'},
        {'3': 'def'}
      ],
      [
        {'4': 'ghi'},
        {'5': 'jkl'},
        {'6': 'mno'}
      ],
      [
        {'7': 'pqrs'},
        {'8': 'tuv'},
        {'9': 'wxyz'}
      ],
      [
        {'*': ''},
        {'0': '+'},
        {'#': ''}
      ],
    ];

    return labels
        .map((row) => Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row
                    .map((label) => ActionButton(
                          title: label.keys.first,
                          subTitle: label.values.first,
                          onPressed: () => _handleNum(label.keys.first),
                          number: true,
                        ))
                    .toList())))
        .toList();
  }

  List<Widget> _buildDialPad() {
    return [
      Container(
          width: 360,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 360,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.black54),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: _textController,
                    )),
              ])),
      Container(
          width: 300,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildNumPad())),
      Container(
          width: 300,
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ActionButton(
                      icon: Icons.dialer_sip,
                      fillColor: Colors.green,
                      onPressed: () async {
                        showchioceDialog(context);
                        // _handleCall(context);
                      }),
                  /* ActionButton(
                    icon: Icons.dialer_sip,
                    fillColor: Colors.green,
                    onPressed: () => _handleCall(context, true),
                  ),*/
                  ActionButton(
                    icon: Icons.keyboard_arrow_left,
                    onPressed: () => _handleBackSpace(),
                    onLongPress: () => _handleBackSpace(true),
                  ),
                ],
              )))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE6E1E0),
        appBar: AppBar(
          backgroundColor: Color(0xffE6E1E0),
          leading: new IconButton(
            icon: new Image.asset('assets/images/_backhome.png'),
            onPressed: () {
              //Navigator.of(context, rootNavigator: true,).pop( context,);
              Navigator.pushNamed(context, '/home');
            },
          ),
          title: InkWell(
            child: IgnorePointer(
                ignoring:
                    true, // You can make this a variable in other toggle True or False
                child: Text('Reddot sip',style:TextStyle(color: Color(0xff133B3A)),)),
          ),
        /*  actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: (String value) {
                  switch (value) {
                    case 'account':
                      Navigator.pushNamed(context, '/register');
                      break;
                    case 'about':
                      Navigator.pushNamed(context, '/register');
                      break;
                    default:
                      break;
                  }
                },
                icon: Icon(Icons.menu),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              child: Text('Account'),
                              width: 64,
                            )
                          ],
                        ),
                        value: 'account',
                      ),
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: Colors.black38,
                            ),
                            SizedBox(
                              child: Text('About'),
                              width: 64,
                            )
                          ],
                        ),
                        value: 'about',
                      )
                    ]),
          ],*/
        ),
        body: Align(
            alignment: Alignment(0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Center(
                        child: Text(
                      'Status: ${EnumHelper.getName(helper!.registerState.state)}',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Center(
                        child: Text(
                      'Received Message: $receivedMsg',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    )),
                  ),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDialPad(),
                  )),
                ])));
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {});
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void callStateChanged(Call call, CallState callState) {
    if (callState.state == CallStateEnum.CALL_INITIATION) {
      Navigator.pushNamed(context, '/callscreen', arguments: call);
      if(iscall==0){
        showCallkitIncoming(Uuid().v4());

      }


    }
    if (callState.state == CallStateEnum.FAILED) {
       FlutterCallkitIncoming.endAllCalls();

      _textController?.text= "";
      iscall=0;
      Navigator.of(context).pop();
      FlutterRingtonePlayer.stop();
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    //Save the incoming message to DB
    String? msgBody = msg.request.body as String?;
    setState(() {
      receivedMsg = msgBody;
    });
  }

  @override
  void onNewNotify(Notify ntf) {}
  void callingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState2) {
            final size = MediaQuery.of(context).size;
            final width = size.width;
            final height = size.height;
            return Scaffold(
                appBar: new AppBar(
                    automaticallyImplyLeading: false,
                    title: new Text("撥號中..."),
                    backgroundColor: Colors.blue),
                body: Container(
                    width: width,
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('撥號中...'),
                        Image.asset('assets/images/calling.gif')
                      ],
                    )));
          });
        });
  }

  void showchioceDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("選擇您要使用的戶別"),
            backgroundColor: Color(0xffE6E1E0),
            content: Container(
                width: width,
                height: height,
                child: new ListView.builder(
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
                        Flexible(
                          child: new Text(
                            widget.profile['houses'][index]
                                    ['constructionName'] +
                                widget.profile['houses'][index]['houseName'],
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              nowwho = widget.profile['houses'][index];
                              UaSettings settings = UaSettings();
                              settings.webSocketUrl =
                                  "wss://ip-intercom.reddotsolution.com:4443/ws";
                              settings.webSocketSettings.allowBadCertificate =
                                  true;
                              //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
                              settings.uri = widget.profile['houses'][index]
                                      ['sipUserName'] +
                                  "@ip-intercom.reddotsolution.com";
                              settings.authorizationUser = widget
                                  .profile['houses'][index]['sipUserName'];
                              settings.password = widget.profile['houses']
                                  [index]['sipUserPassword'];
                              settings.displayName =
                                  widget.profile['houses'][index]['houseName'];
                              settings.userAgent = 'Dart SIP Client v1.0.0';
                              settings.dtmfMode = DtmfMode.RFC2833;
                              print("setting:" +
                                  settings.webSocketUrl.toString());
                              helper!.start(settings);
                              print("get:"+widget.get.toString());
                              if(widget.get.toString()=="1"){
                                Navigator.pop(context);
                                _textController?.text=widget.profile['houses'][index]['constructionSipUserName'];
                                iscall=1;
                                await Future.delayed(const Duration(seconds: 1));

                                _handleCall(context);

                              }
                              else{
                                Navigator.pop(context);
                                print("heree:"+ widget.profile['houses'][index]['houseID'].toString());
                                var get = await APIs().startcall(
                                    widget.info['token'],
                                    widget.profile['houses'][index]
                                    ['constructionId'],
                                    widget.profile['houses'][index]['houseID'],
                                    _textController?.text);
                                var respone = json.decode(get);
                                if (respone['code'] != 0) {
                                  //   callingDialog();
                                  Fluttertoast.showToast(
                                      msg: respone['message'],
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      backgroundColor: Colors.black,
                                      fontSize: 16.0);
                                }
                                else{
                                  _textController?.text= respone['data']['targetSipName'];
                                  iscall=1;
                                  await Future.delayed(const Duration(seconds: 1));
                                  _handleCall(context);

                                }
                              }


                            },
                            child: Text("選擇"))
                      ],
                    ));
                  },
                )),
          );
        });
  }
}
