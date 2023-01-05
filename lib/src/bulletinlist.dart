import 'package:dart_sip_ua_example/src/register.dart';
import 'package:dart_sip_ua_example/src/sipphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:sip_ua/sip_ua.dart';

class bulletinlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _bulletinlist();
  }
}
class _bulletinlist extends State<bulletinlist> {
  @override
  void initState() {
    bulletintext.add("一、本公寓大廈（社區）於 104 年 07 月 01 日召集區分所有權人會議因□未達定額或▓未獲致決議\n"
        + "，復於 104 年 07 月 30 日依公寓大廈管\n"
        + "理條例第三十二條第一項之規定，就同一議案重新召集區分所有權人\n"
        + "會議，經達法定數額作成決議事項，先予敘明。\n"
        + "二、上開會議之會議紀錄，業依同條例第三十四條第一項規定，於會後十\n"
        + "五日(送達日 104 年 08 月 03 日)內送達各區分所有權人並公告之，\n"
        + "經逾七日尚無超過全體區分所有權人及其區分所有權比例合計半數以\n"
        + "上，以書面表示反對意見，該次會議之決議視為成立，特此公告。\n"
        + "三、本公告之內容如有不實，概由本人依法負責。");
    bulletintext.add("一、本公寓大廈（社區）於 104 年 07 月 01 日召集區分所有權人會議因□未達定額或▓未獲致決議\n"
        + "，復於 104 年 07 月 30 日依公寓大廈管\n"
        + "理條例第三十二條第一項之規定，就同一議案重新召集區分所有權人\n"
        + "會議，經達法定數額作成決議事項，先予敘明。\n"
        + "二、上開會議之會議紀錄，業依同條例第三十四條第一項規定，於會後十\n"
        + "五日(送達日 104 年 08 月 03 日)內送達各區分所有權人並公告之，\n"
        + "經逾七日尚無超過全體區分所有權人及其區分所有權比例合計半數以\n"
        + "上，以書面表示反對意見，該次會議之決議視為成立，特此公告。\n"
        + "三、本公告之內容如有不實，概由本人依法負責。");
    bulletintext.add("敬愛的  住戶您好：\n"
        + "本社區管理委員會作成決議，本社區公共使用部分，包括大廳、樓梯間、走道、公用廁所等公共設施，自即日起全面禁菸，煩請各位住戶配合。\n"
        + "私人住家雖未列為菸害防制法之禁菸場所，但室內吸菸時，除二手菸危害家人健康外，也會沿著衛浴間、管道間、天井及其他通風縫隙鑽進其他住戶，或因陽台相緊鄰而飄散，常常造成芳鄰困擾，甚至衍生居家糾紛，傷害社區和諧。\n"
        + "有鑑於為此，敬懇請各位癮君子避免在家中吸菸，吸菸請務必在大樓指定之戶外吸菸區，或戶外其他空曠處，以避免影響他人為宜。\n"
        + "祝福 所有住戶\n"
        + "家家 健康快樂！\n"
        + "○○管理委員會 敬上\n");
    bulletintext.add("社區公告\n"
        + " 主旨：住戶反應意見流程說明\n"
        + " 說明：\n"
        + " 親愛的住戶您好：\n"
        + "     為使住戶反應意見處理流程之一"
        + " 致，如各位住戶有寶貴的建議、意見"
        + " 請統一至管理中心櫃台填寫住戶反應"
        + " 意見單，且請於管委會會議前二日交"
        + " 至管理中心，社區主任彙整後，將提"
        + " 交予管委會。\n"
        + "     管委會非常重視住戶之意見，為\n"
        + " 盡速處理您的建議，敬請住戶配合，\n"
        + " 謝謝您。");
  imageurl.add("https://d.share.photo.xuite.net/parisgarden/1d669af/13091230/663473425_m.jpg");
  imageurl.add("https://d.share.photo.xuite.net/parisgarden/1d669af/13091230/663473425_m.jpg");
  imageurl.add("https://img.ltn.com.tw/Upload/news/600/2021/09/15/3672722_1_1.jpg");
  imageurl.add("https://cdn2.ettoday.net/images/5728/d5728175.jpg");
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
            title: new Text("社區公告"),
            backgroundColor:Color(0xffE6E1E0) ,
        ),
        body: SingleChildScrollView(
            child: new ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bulletintext.length == 0 ? 0 : bulletintext.length,
              itemBuilder: (BuildContext context, int index){
                return new Card(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: new Text(bulletintext[index],softWrap: false,overflow: TextOverflow.ellipsis,maxLines: 2,),),
                        ElevatedButton(onPressed: (){
                              nowpage=index;
                              showBulltinDialog(context);
                        }, child: Text("詳細內容..."))
                      ], )
                );
              },
            ),
           )
    );
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
                          child: Text(bulletintext[nowpage]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(onPressed:nowpage==0?null:(){
                              setState(() {
                                nowpage--;
                                Navigator.pop(context);
                                showBulltinDialog(context);
                              });
                            }, child: Text("上一則")),
                            Expanded(child:Image.network(imageurl[nowpage]),),
                            ElevatedButton(onPressed:nowpage==totalpage?null:(){
                              setState(() {
                                nowpage++;
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


