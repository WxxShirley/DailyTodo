import 'package:flutter/material.dart';
import 'package:todo/common/fonts.dart';

class HintToast extends StatelessWidget
{
  final String content;
  HintToast({String content}):this.content = content;
  
   @override
  Widget build(BuildContext context)
  {
    return Container(
      color: Colors.black.withOpacity(0.7),
      width: 180.0,
      height: 60.0,
      margin: EdgeInsets.all(15.0),
      child: 
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(Icons.info,color:Colors.white),
           Text(content, style: bottomTextStyle),
         ],
        )
    );
  }
}