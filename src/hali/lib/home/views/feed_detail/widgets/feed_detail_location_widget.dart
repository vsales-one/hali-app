import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/models/post_model.dart';

class FeedDetailLocationWidget extends StatelessWidget {
  final PostModel postModel;

  FeedDetailLocationWidget({this.postModel});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(top: 70),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            child: Icon(
                              Icons.date_range,
                              color: Colors.black54,
                            ),
                            padding: EdgeInsets.only(right: 16),
                          ),
                          Expanded(
                            child: Text(
                              "Pickup Time: " + postModel.pickupTimeDisplay(),
                              style:
                                  Styles.getSemiboldStyle(14, Colors.black54),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.black54,
                            ),
                            padding: EdgeInsets.only(right: 16),
                          ),
                          Expanded(
                            child: Text(
                              postModel.pickupAddress ?? "",
                              style:
                                  Styles.getSemiboldStyle(14, Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Padding(
                          child: Icon(
                            Icons.share,
                            color: Colors.black54,
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                      ),
                      Container(
                        child: Padding(
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.black54,
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                )
              ],
            )),
      ],
    ));
  }
}
