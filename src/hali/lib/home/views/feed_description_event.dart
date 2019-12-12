import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';

class FeedDescriptionEvent extends StatelessWidget {
  final String title;
  FeedDescriptionEvent({this.title});
  
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(this.title ?? "", style: Styles.getSemiboldStyle(16, Colors.black87), textAlign: TextAlign.left,)
        )
    );
  }

}