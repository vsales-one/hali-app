import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';

class FeedDescriptionEvent extends StatelessWidget {
  final String title;
  FeedDescriptionEvent({this.title});

  @override
  Widget build(BuildContext context) {
    final words = title == null || title.isEmpty ? [] : title.trim().split(" ");
    final shortTitle =
        words.length > 4 ? "${words.sublist(0, 3).join(" ")}..." : title;
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              shortTitle ?? "",
              style: Styles.getSemiboldStyle(24, Colors.black87),
              textAlign: TextAlign.left,
            )));
  }
}
