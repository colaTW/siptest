// @dart=2.9
import 'dart:convert';
import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:sip_ua/sip_ua.dart';

import 'APIs.dart';

class messagelist extends StatefulWidget {
  dynamic info;
  var width;
  messagelist(this.info,this.width,{Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _messagelist();
  }
}
class _messagelist extends State<messagelist>{
  var isDisable=false;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  var type = 0;
  var Category = 0;
  var ItemID;
  var Categories;
  var HandlerTypes;
  var Itmes;
  int pagecounter=1;
  int totalpage1=1;
  int minspage=1;
  int pluspage=1;
  int how;
  var items = <ItemInfo>[];
  List<Widget> itemsData = [];
  var member_info;
  void initState() {
    this.getlist(0);
    print("list"+widget.info.toString());

  }
  void getlist(int mins) async {
      var re = json.decode(await APIs().getlist_member(widget.info['token'], type, Category,ItemID,pagecounter));
      //var re= json.decode('{"projectCategories":[{"id":0,"name":"\u5168\u90e8"},{"id":1,"name":"\u6f0f\u6c34"},{"id":2,"name":"\u5730\u78da"},{"id":3,"name":"\u58c1\u78da"},{"id":4,"name":"\u8a2d\u5099"},{"id":5,"name":"\u6cb9\u6f06"},{"id":6,"name":"\u5176\u4ed6"}],"projectItems":{"1":[{"id":0,"name":"\u5168\u90e8"},{"id":1,"name":"\u5916\u7246"},{"id":2,"name":"\u6d74\u5ba4"},{"id":3,"name":"\u7ba1\u8def"},{"id":4,"name":"\u967d\u53f0"},{"id":5,"name":"\u5730\u4e0b\u5ba4"}],"2":[{"id":0,"name":"\u5168\u90e8"},{"id":6,"name":"\u7834\u640d"},{"id":7,"name":"\u7a7a\u5fc3"}],"3":[{"id":0,"name":"\u5168\u90e8"},{"id":8,"name":"\u7834\u640d"},{"id":9,"name":"\u7a7a\u5fc3"}],"4":[{"id":0,"name":"\u5168\u90e8"},{"id":10,"name":"\u96fb\u5b50&\u5176\u4ed6"},{"id":11,"name":"\u5eda\u623f"},{"id":12,"name":"\u6d74\u5ba4"},{"id":13,"name":"\u9580\u7a97"},{"id":14,"name":"\u6276\u624b\u6b04\u6746"}],"5":[{"id":0,"name":"\u5168\u90e8"},{"id":15,"name":"\u7121"}],"6":[{"id":0,"name":"\u5168\u90e8"},{"id":16,"name":"\u5176\u4ed6"}]},"projectHandlerTypes":[{"id":0,"name":"\u6240\u6709"},{"id":1,"name":"\u89c0\u5bdf\u4e2d"},{"id":2,"name":"\u8655\u7406\u4e2d"},{"id":3,"name":"\u6848\u4ef6\u7d50\u6848"},{"id":4,"name":"\u696d\u5916\u8655\u7406"},{"id":5,"name":"\u4f4f\u6236\u81ea\u884c\u8655\u7406"}],"projectLists":[{"projectId":37,"memerId":2,"constructionName":"\u6e2c\u8a66B","constructionCode":"del_1670332260_00001","overResidentWarranty":"","projectCategoryName":"\u6cb9\u6f06","projectItemName":"\u7121","repair":{"name":"cola","phone":"0963980821","mobile":"0963980821","email":null,"constructionName":"\u6e2c\u8a66B","address":"123456789","building":null,"household":null,"floor":null,"message":"owo"},"handlerTypeCode":1,"handlerType":"\u672a\u8655\u7406","createdAt":"2022-12-12 10:25:41","member":{"id":2,"account":"0821","name":"cola","mobile":"0911123123","email":"aa1@gmail.com"},"images":[],"files":[],"handlers":[]},{"projectId":36,"memerId":2,"constructionName":"\u6e2c\u8a66B","constructionCode":"del_1670332260_00001","overResidentWarranty":"","projectCategoryName":"\u6cb9\u6f06","projectItemName":"\u7121","repair":{"name":"cola","phone":"0963980821","mobile":"0963980821","email":null,"constructionName":"\u6e2c\u8a66B","address":null,"building":null,"household":null,"floor":null,"message":"owo"},"handlerTypeCode":1,"handlerType":"\u672a\u8655\u7406","createdAt":"2022-12-12 10:24:58","member":{"id":2,"account":"0821","name":"cola","mobile":"0911123123","email":"aa1@gmail.com"},"images":[],"files":[],"handlers":[]},{"projectId":35,"memerId":2,"constructionName":"\u6e2c\u8a66B","constructionCode":"del_1670332260_00001","overResidentWarranty":"","projectCategoryName":"\u58c1\u78da","projectItemName":"\u7a7a\u5fc3","repair":{"name":"\u6e2c\u8a66B","phone":null,"mobile":null,"email":null,"constructionName":"\u6e2c\u8a66B","address":null,"building":null,"household":null,"floor":null,"message":""},"handlerTypeCode":1,"handlerType":"\u672a\u8655\u7406","createdAt":"2022-12-12 10:04:40","member":{"id":2,"account":"0821","name":"cola","mobile":"0911123123","email":"aa1@gmail.com"},"images":[],"files":[],"handlers":[]},{"projectId":31,"memerId":2,"constructionName":"\u6e2c\u8a66B","constructionCode":"del_1670332260_00001","overResidentWarranty":"","projectCategoryName":"\u5730\u78da","projectItemName":"\u7834\u640d","repair":{"name":"\u6e2c\u8a66B","phone":null,"mobile":null,"email":null,"constructionName":"\u6e2c\u8a66B","address":null,"building":null,"household":null,"floor":null,"message":"io"},"handlerTypeCode":4,"handlerType":"\u696d\u5916\u8655\u7406","createdAt":"2022-12-09 15:25:55","member":{"id":2,"account":"0821","name":"cola","mobile":"0911123123","email":"aa1@gmail.com"},"images":[],"files":[],"handlers":[{"handlerId":32,"message":"","price":0,"onSite":"\u5426","onSiteAt":"2022-12-22","handlerType":"\u696d\u5916\u8655\u7406","clientAgree":"\u5426","clientAgreeAt":"","clientSignImage":"https:\/\/rsd.edwardforce.tw\/images\/default.jpg","memberId":2,"memberName":"cola","createdAt":"2022-12-09 15:57:24","images":[],"files":[]}]},{"projectId":29,"memerId":2,"constructionName":"\u6e2c\u8a66B","constructionCode":"del_1670332260_00001","overResidentWarranty":"","projectCategoryName":"\u8a2d\u5099","projectItemName":"\u6d74\u5ba4","repair":{"name":"\u6e2c\u8a66B","phone":null,"mobile":null,"email":null,"constructionName":"\u6e2c\u8a66B","address":"uiopp","building":null,"household":null,"floor":null,"message":""},"handlerTypeCode":1,"handlerType":"\u672a\u8655\u7406","createdAt":"2022-12-09 12:23:02","member":{"id":2,"account":"0821","name":"cola","mobile":"0911123123","email":"aa1@gmail.com"},"images":[{"id":9,"name":"6392b812cfc5f.jpeg","url":"https:\/\/rsd.edwardforce.tw\/upload\/projectImages\/6392b812cfc5f.jpeg"},{"id":10,"name":"6392b8236f9cc.jpeg","url":"https:\/\/rsd.edwardforce.tw\/upload\/projectImages\/6392b8236f9cc.jpeg"}],"files":[],"handlers":[{"handlerId":30,"message":"qwe","price":0,"onSite":"\u5426","onSiteAt":"2022-12-22","handlerType":"\u672a\u8655\u7406","clientAgree":"\u5426","clientAgreeAt":"","clientSignImage":"https:\/\/rsd.edwardforce.tw\/images\/default.jpg","memberId":2,"memberName":"cola","createdAt":"2022-12-09 12:30:56","images":[],"files":[]},{"handlerId":29,"message":"ffff","price":0,"onSite":"\u5426","onSiteAt":"2022-12-22","handlerType":"\u672a\u8655\u7406","clientAgree":"\u5426","clientAgreeAt":"","clientSignImage":"https:\/\/rsd.edwardforce.tw\/images\/default.jpg","memberId":2,"memberName":"cola","createdAt":"2022-12-09 12:26:28","images":[],"files":[{"id":14,"name":"20211101CoolBe_PANDORA LINE API\u8207\u6703\u54e1\u8cc7\u6599\u4e32\u63a5_6392b847494be.pdf","url":"https:\/\/rsd.edwardforce.tw\/upload\/handlerFiles\/20211101CoolBe_PANDORA LINE API\u8207\u6703\u54e1\u8cc7\u6599\u4e32\u63a5_6392b847494be.pdf"}]}]}],"projectCounts":8,"totalPages":2,"currentPage":1,"currentProjectCategoryId":0,"currentHandlerType":0}');
      print(re.toString());
      Categories=re['projectCategories'];
      Itmes=re['projectItems'];
      HandlerTypes=re['projectHandlerTypes'];
      for(int i=1;i<=Itmes.length;i++){
        Itmes[i.toString()]=Itmes[i.toString()];
      }
      var go = <ItemInfo>[];
      print(re['projectLists']);
      for (int i = 0; i < re['projectLists'].length; i++) {
        print( re['projectLists'][i]['createdAt']);
        var goinfo = ItemInfo();
        goinfo.housename= re['projectLists'][i]['repair']['houseName'];

        goinfo.deal_no = re['projectLists'][i]['projectId'].toString();
        goinfo.deal_type = re['projectLists'][i]['projectItemName'] +
            re['projectLists'][i]['projectCategoryName'];
        goinfo.deal_newdate = re['projectLists'][i]['createdAt'];
        goinfo.deal_info = re['projectLists'][i]['repair']['name'];
        goinfo.deal_case = re['projectLists'][i]['repair']['constructionName'];
        goinfo.deal_type_newdate = re['projectLists'][i]['projectItemName'] +
            re['projectLists'][i]['projectCategoryName'] + '\n' +
            re['projectLists'][i]['createdAt'];
        goinfo.deal_phone = re['projectLists'][i]['repair']['mobile'];
        goinfo.deal_status = re['projectLists'][i]['handlerType'];
        goinfo.deal_name = re['projectLists'][i]['repair']['name'];
        goinfo.deal_messg = re['projectLists'][i]['repair']['message'];
        goinfo.deal_email = re['projectLists'][i]['repair']['email'];
        goinfo.deal_address = re['projectLists'][i]['repair']['address'];
        goinfo.building=re['projectLists'][i]['repair']['constructionName'];
        goinfo.buildinfo=re['projectLists'][i]['repair']['building'].toString()+'棟'+re['projectLists'][i]['repair']['household'].toString()+'戶'+re['projectLists'][i]['repair']['floor'].toString()+'樓';
        goinfo.Warranty=re['projectLists'][i]['overResidentWarranty'];
        goinfo.page=re['currentPage'];
        goinfo.deal_img1 = ['', '', '', '', ''];
        goinfo.handler_img1 = ['', '', '', '', ''];
        totalpage1 = re['totalPages'];
        goinfo.createManager=re['projectLists'][i]['createManager'].length;
        goinfo.hadlerlength=re['projectLists'][i]['handlers'].length;
        if (re['projectLists'][i]['handlers'].length > 0) {
          goinfo.deal_onsite = re['projectLists'][i]['handlers'][0]['onSite'];
          goinfo.deal_onsiteat = re['projectLists'][i]['handlers'][0]['onSiteAt'];
          goinfo.handler_message=re['projectLists'][i]['handlers'][0]['message'];
          goinfo.handler_createManagerName=re['projectLists'][i]['handlers'][0]['createManagerName'];
          for (int j = 0; j < re['projectLists'][i]['handlers'][0]['images'].length; j++) {
            goinfo.handler_img1[j] = re['projectLists'][i]['handlers'][0]['images'][j]['url'];
          }
        }
        for (int j = 0; j < re['projectLists'][i]['images'].length; j++) {
          goinfo.deal_img1[j] = re['projectLists'][i]['images'][j]['url'];
        }
        goinfo.memos=re['projectLists'][i]['memos'];
        go.add(goinfo);
      }
      items = go;
      getPostsData(items,mins);

  }
  void getPostsData(var list,int mins) {
    List<Widget> listItems = [];
    for(int i=0;i<list.length;i++) {
      print(list[i].hadlerlength);
      String show='';
      if(list[i].deal_status=='案件結案'){show=list[i].deal_status;}
      else if(list[i].deal_status=='業外處理'){show=list[i].deal_status;}
      else if(list[i].deal_status=='會員自行處理'){show=list[i].deal_status;}
      Color cardcolor;
      cardcolor=Colors.white;
      /*偵測保固過期卡片變色
      if(list[i].Warranty==true){
        cardcolor=Color(0xFFDBADD2);
      }
      else{
        cardcolor=Colors.white;
      }*/
    /*  if(list[i].hadlerlength>0){
        listItems.add(Container
          (
          decoration: BoxDecoration(
              border:Border(bottom:BorderSide(width: 2,color:Colors.grey) )),
            margin: const EdgeInsets.only(bottom:10 ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Container(width: widget.width/10*3,child: Flexible(child: new Text(list[i].deal_onsiteat,softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 4,textAlign: TextAlign.left),)),

                  list[i].hadlerlength==0?list[i].createManager==0?Container(width: widget.width/10,child:Text("")):Container(width: widget.width/10,child: ImageIcon(AssetImage("assets/images/p21.png"))):Container(width: widget.width/10,child: ImageIcon(AssetImage("assets/images/p20.png"))),
                  Container(width: widget.width/10*3,child: Flexible(child: new Text(list[i].handler_message,softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 4,textAlign: TextAlign.left),)),
                  IconButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff7588FA)),
                      onPressed: (){
                    showdetailDialog(context,list[i]);
                  }, icon:Image.asset("assets/images/p19.png"),iconSize: 50,),
                ],
              ),
            )));
      }*/

     listItems.add(Container(
          margin: const EdgeInsets.only(bottom:10 ),
         decoration: BoxDecoration(
             border:Border(bottom:BorderSide(width: 2,color:Colors.grey) )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                list[i].deal_newdate==null?Text(""):Container(width: widget.width/10*3,child: Flexible(child: new Text(list[i].deal_newdate,softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 4,textAlign: TextAlign.left),)),

                list[i].hadlerlength==0?list[i].createManager==0?Container(width: widget.width/10,child:Text("")):Container(width: widget.width/10,child: Image.asset("assets/images/p20.png")):Container(width: widget.width/10,child: Image.asset("assets/images/p21.png")),
                list[i].deal_messg==null?Text(""): Container(width: widget.width/10*3,child: Flexible(child: new Text(list[i].deal_messg,softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 4,textAlign: TextAlign.left),)),


                IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7588FA)),
                  onPressed: (){
                    showdetailDialog(context,list[i]);
                  }, icon:Image.asset("assets/images/p19.png"),iconSize: 50,),
              ],
            ),
          )));
    };
    if(mins==0){
      setState(() {
        itemsData+= listItems;
      });
    }
    else{
      setState(() {
        itemsData= listItems+itemsData;
      });
    }

  }
  Future<String> getDate() async{
    getlist(0);
    return 'success';
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE6E1E0),
        title: Text("回饋 提醒",style:TextStyle(color: Color(0xff133B3A))),
        actions: [          
          IconButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff7588FA)
            ),
            onPressed: (){
          Navigator.pushNamed(context, '/messagefix');
        }, icon: Image.asset("assets/images/p18.png"),iconSize: 50,)],
      ),
      body:
      Container(
        height: height+1,
        color:Color(0xffE6E1E0) ,
        child:Column(
          children: [
            SizedBox(height: 10,),
            SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child:
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                    child:
                    Column(
                      children: [

                        /*Row(children: <Widget>[
                          HandlerTypes!=null? new Expanded(
                              child: new DropdownButton<dynamic>(
                                isExpanded: true,
                                hint:Center(child: Text('請選擇分類',textAlign: TextAlign.center)),
                                items: HandlerTypes.map<DropdownMenuItem<dynamic>>((item) {
                                  return new DropdownMenuItem<dynamic>(
                                    child: Center(child:new Text(item['name'])),
                                    value: item['id'],
                                  );
                                }).toList(),
                                onChanged: (selectvalue) {
                                  print(selectvalue);
                                  setState(() {
                                    type=selectvalue;
                                  });
                                },
                                value: type,
                              )):Text(''),
                          Padding(padding:EdgeInsets.only(right:37.0,) ,
                              child:new ElevatedButton( style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff7588FA)
                          ),child: Text("搜尋"),
                              onPressed:isDisable?null:
                                  () async{
                                setState(() {
                                  isDisable=true;
                                });
                                pagecounter=1;
                                minspage=1;
                                pluspage=1;
                                itemsData=[];
                                await getlist(0);
                                if(mounted){
                                  setState(() {
                                    isDisable=false;
                                  });
                                }
                              })),
                        ],
                        ),*/
                      ],
                    ))),
            SizedBox(height: 10,),

            Expanded(child:
            new NotificationListener(
                onNotification: dataNotification,
                child:
                ListView.builder(
                    controller: controller,
                    itemCount: itemsData.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (topContainer > 0.5) {
                        scale = index + 0.5 - topContainer;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform:  Matrix4.identity()..scale(scale,scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    }))),
            /*  Row(
                children: <Widget>[
                  new RaisedButton(
                    onPressed: _minus,
                    child: new Icon(Icons.arrow_back_ios),
                  ),
                    Text(pagecounter.toString()+"/"+totalpage1.toString()),
                    new RaisedButton(
                    onPressed: _plus,
                    child: new Icon(Icons.arrow_forward_ios),
                  ),
                ],
              )*/
          ],
        ),
      ),

    );


  }
  bool dataNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      //下滑到最底部
      if (notification.metrics.extentAfter == .0) {
        _plus();
        return true;
      }
      if(notification.metrics.extentBefore==0.0){
        _minus();
        return true;
      }
    }
  }
  _minus() async{
    print('mins');
    print(pagecounter);
    print(minspage);
    if(pagecounter==1){}
    else if(pagecounter>minspage){
      setState(() {
        pagecounter=minspage;
      });}
    else {
      setState(() {
        pagecounter--;
        minspage--;
      });
      getlist(1);
    }
  }
  _plus() async{
    print(pagecounter);

    if(pagecounter==totalpage1){}
    else if(pagecounter<pluspage){
      setState(() {
        pagecounter=pluspage;
      });}

    else {
      setState(() {
        pagecounter++;
        pluspage++;
      });
      print(pagecounter);
      await getlist(0);
    }
  }
}
class ItemInfo {
  String deal_no;
  String deal_type;
  String deal_newdate;
  String deal_type_newdate;
  String deal_info;
  String deal_case;
  String deal_info_case;
  String deal_phone;
  String deal_status;
  String deal_name;
  String deal_address;
  String deal_email;
  String deal_messg;
  String deal_onsite;
  String deal_onsiteat;
  String building;
  String buildinfo;
  var hadlerlength;
  var page;
  var deal_img1;
  var handler_img1;
  var Warranty;
  var createManager;
  String memos;
  String handler_message;
  String housename;
  String handler_createManagerName;


  ItemInfo({
    this.deal_no,
    this.deal_type_newdate,
    this.deal_info_case,
    this.deal_phone,
    this.deal_status,
    this.deal_name,
    this.deal_address,
    this.deal_email,
    this.deal_messg,
    this.deal_img1,
    this.deal_case,
    this.deal_info,
    this.deal_newdate,
    this.deal_type,
    this.deal_onsite,
    this.deal_onsiteat,
    this.building,
    this.buildinfo,
    this.Warranty,
    this.page,
    this.memos,
    this.handler_message,
    this.housename,
    this.hadlerlength,
    this.handler_img1,
    this.handler_createManagerName,
    this.createManager,

  });
}
void showdetailDialog(BuildContext context,var show) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("詳細資料"),
              SizedBox(height: 5,),
              Container(width: double.infinity,child:
              DecoratedBox(
                decoration:BoxDecoration(
                    border:Border.all(color: Colors.grey,width: 1.0)
                ),
              )),
            ],),
          content:
          Container(height: height*0.5,child:
          SingleChildScrollView(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Text("我的意見:"+show.deal_messg),
              Container(width: double.infinity,child:
              DecoratedBox(
                decoration:BoxDecoration(
                    border:Border.all(color: Colors.grey,width: 1.0)
                ),
              )),
              SizedBox(height: 10,),

              show.hadlerlength==0?Text("尚未回覆"):Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  show.deal_name==null?Text(""):new Text('回覆人員:\n'+show.handler_createManagerName,style:TextStyle(height: 1.5)),
                  SizedBox(height: 15,),
                  show.handler_message==null?Text(''): new Text('回覆訊息:\n'+show.handler_message),
                  SizedBox(height: 15,),
                  new Text('回覆照片:'),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      show.handler_img1[0]==''?Text(''): Expanded(child:GestureDetector(child:new Image(image: NetworkImage(show.handler_img1[0]),)
                        ,onTap: (){
                          showImageDialog(context, show.handler_img1[0]);
                        },)),
                      SizedBox(width: 5,),
                      show.handler_img1[1]==''?Text(''): Expanded(child:GestureDetector(child:new Image(image: NetworkImage(show.handler_img1[1]),)
                        ,onTap: (){
                          showImageDialog(context, show.handler_img1[1]);
                        },)),
                      SizedBox(width: 5,),
                      show.handler_img1[2]==''?Text(''):Expanded(child:GestureDetector(child:new Image(image: NetworkImage(show.handler_img1[2]),)
                        ,onTap: (){
                          showImageDialog(context, show.handler_img1[2]);
                        },)),
                      SizedBox(width: 5,),
                      show.handler_img1[3]==''?Text(''): Expanded(child:GestureDetector(child:new Image(image: NetworkImage(show.handler_img1[3]),)
                        ,onTap: (){
                          showImageDialog(context, show.handler_img1[3]);
                        },)),
                      SizedBox(width: 5,),
                      show.handler_img1[4]==''?Text(''):Expanded(child:GestureDetector(child:new Image(image: NetworkImage(show.handler_img1[4]),)
                        ,onTap: (){
                          showImageDialog(context, show.handler_img1[4]);
                        },)),
                    ],),
                ],
              ),

              //show.memos==null?Text('保固備註:\n'):new Text('保固備註:\n'+show.memos),

              SizedBox(height: 15,),

              //new Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //  children: <Widget>[
              //    show.deal_img1[3]==''?Text(''): Expanded(child:new Image(image: NetworkImage(show.deal_img1[3]),)),
              //    show.deal_img1[4]==''?Text(''): Expanded(child:new Image(image: NetworkImage(show.deal_img1[4]),)),
              //  ],),
            ],))),
          actions: <Widget>[
            new TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("確認"),
            ),

          ],
        );
      });
}
void showImageDialog(BuildContext context,var imgurl) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          content: Container(
            width: width,
            height:height ,
            child:
            PinchZoom(
              child: Image.network(imgurl),
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 3.5,
            ),
          ),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("確認"),
            ),

          ],
        );
      });
}


