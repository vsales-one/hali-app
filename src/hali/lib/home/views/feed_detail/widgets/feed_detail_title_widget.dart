import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/models/post_model.dart';

class FeedDetailTitleWidget extends StatelessWidget {
  final PostModel postModel;

  FeedDetailTitleWidget({this.postModel});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      postModel.title ?? "",
                      style: Styles.getSemiboldStyle(25, Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    postModel.description ?? "",
                    style: Styles.getRegularStyle(16, Colors.black54),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ))
      ]),
    );
  }
}