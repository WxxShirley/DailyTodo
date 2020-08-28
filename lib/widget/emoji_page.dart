import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';


// 这里是一个demo，实际上没有用到.......
//  功能是选择了一个emoji后可以在下方区域任意拖动
class EmojiDemo extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text("Emoji Demo"),),
      body: EmojiPage(),
    );
  }
}

class EmojiPage extends StatefulWidget
{
  @override
  _EmojiPage createState() => new _EmojiPage();
}

Widget toast(String text)
{
  return Center(
    child: ClipRRect(borderRadius: BorderRadius.circular(30.0),
      child:Container(
        width: 210.0,
        height: 50.0,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.3),
        child:
         Row(children: [
           Icon(Icons.notifications,size:30.0, color: Colors.blue,),
           Text(" Choose emoji:"+text, style: TextStyle(fontSize: 20.0),),
         ],)
      )
    ),
  );
}


class _EmojiPage extends State<EmojiPage>
{
  String _chosenEmoji;

  double _top=300, _left=50;

  @override
  Widget build(BuildContext context){
    return 
   Column(
      children: [
      EmojiPicker(
        rows: 3,
        columns: 7,
        recommendKeywords: ["racing","horse"],
        numRecommended: 10,
        onEmojiSelected: (emoji, category){ //showToastWidget(toast(emoji.emoji)); 
          setState(() {
              _chosenEmoji = emoji.emoji;
            });
          },
        ),
      
      Expanded(child:Stack(
        overflow: Overflow.visible,
      children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: _chosenEmoji==null?CircularProgressIndicator():Text(_chosenEmoji,style: TextStyle(fontSize:30.0),),
              onPanUpdate: (DragUpdateDetails e){
                setState(() {
                  _left += e.delta.dx;
                  _top += e.delta.dy;
                });
              },
            )
          ),
      ],
    ),
   )],);
  }
}


