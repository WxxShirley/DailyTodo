import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:todo/common/fonts.dart';


class PickMood extends StatefulWidget
{
  final String date;
  PickMood({String date}):this.date = date;

   @override
  _PickMood createState() => _PickMood(date: date);
}

class _PickMood extends State<PickMood>
{
  String _chosenEmoji;

  final String date;
  _PickMood({String date}):this.date = date;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择心情${date}"),
        leading: IconButton(icon:Icon(Icons.chevron_left),onPressed: (){
          Navigator.pop(context,"");
        }, ),
      ),
      body: 
        Column(
          children: [
            EmojiPicker(
              rows: 5,
              columns: 7,
              numRecommended: 10,
              onEmojiSelected: (emoji, category){ //showToastWidget(toast(emoji.emoji)); 
                setState(() {
                  _chosenEmoji = emoji.emoji;
                });
              },
            ),
            
            Expanded(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                _chosenEmoji==null? 
                 Text("尚未选择心情",style: text,):
                 Text("已选择心情:"+_chosenEmoji, style: text,),
                
                const SizedBox(height:30.0),

                _chosenEmoji==null?Container():

                Container(
                  width: 130.0,
                  child:
                 FloatingActionButton.extended(
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                   label: Text("确定",style: text.copyWith(color:Colors.white)),
                   onPressed: (){
                     print("confirm emoji");
                     Navigator.pop(context, _chosenEmoji);
                   },
                 )
              )])
              )
            ]
            )
    );
  }
}
