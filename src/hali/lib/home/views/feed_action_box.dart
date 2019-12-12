import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/models/post_model.dart';

class FeedActionBox extends StatelessWidget {
  final double radius = 14.0;
  final PostModel postModel;

  FeedActionBox({this.postModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                this.postModel.distance != null
                    ? Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                            ),

                            // show comments
                            Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "32 km",
                                    style: Styles.getSemiboldStyle(
                                        12, Colors.black54),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : new Container(),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.monetization_on,
                          size: 20,
                        ),
                      ),

                      // show comments
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Free",
                              style:
                                  Styles.getSemiboldStyle(12, Colors.black54),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // button

          // show like
          this.postModel.numberLike != null
              ? Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: new Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "$postModel.numberLike ?? 0",
                          style: Styles.getSemiboldStyle(12, Colors.black54),
                        ),
                      )
                    ],
                  ),
                )
              : new Container()
        ],
      ),
    );
  }
}
