import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hali/commons/color_utils.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/di/appModule.dart';

class FeedCard extends StatelessWidget {

  final Function onTapCard;

  const FeedCard({Key key, this.onTapCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          // top
          _ContainerTop(),
          //body
          _BodyImage(onTap: onTapCard,),
          //action
          _ActionBox(),
          //Description
          _DescriptionEvent(),
        ],
      ),
    );
  }
}

class _ContainerTop extends StatelessWidget {
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
                // avatar
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                // name
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Trung vu",
                        style: Styles.getSemiboldStyle(14, Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                      Text("Last online 3 mins ago",
                          style: Styles.getRegularStyle(12, Colors.grey[500]),
                          textAlign: TextAlign.left)
                    ],
                  ),
                ),
              ],
            ),
          ),
          // button

          Container(
            padding: EdgeInsets.all(8),
            child: GestureDetector(

              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: ColorUtils.hexToColor(colorF0857A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                    child: Text("Follow", style: Styles.getRegularStyle(12, Colors.white),),
                  ),
                ],
              ),
              onTap: () {
                logger.d("You followed");
              },
            ),
          )
        ],
      ),
    );
  }
}


class _BodyImage extends StatelessWidget {

  final VoidCallback onTap;

  const _BodyImage({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthImage = MediaQuery.of(context).size.width - 16;
    final d = DateTime.now().toString();
    return GestureDetector(
      child: Container(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "123@{$d}",
              child: CachedNetworkImage(
                imageUrl: "https://images.unsplash.com/photo-1537758069025-b07fb3548d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2752&q=80",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            )
          ],
        )
      ),
      onTap: onTap,
    );
  }
}

class _DescriptionEvent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text("Drink 3 beers in 5 mins. ", style: Styles.getSemiboldStyle(14, Colors.black87), textAlign: TextAlign.left,)
      )
    );
  }

}


class _ActionBox extends StatelessWidget {

  final double radius = 14.0;

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
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: radius*2*2,
                          ),
                          Positioned(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: radius,
                              child: CircleAvatar(
                                radius: radius - 2,
                              ),
                            ),
                          ),

                          Positioned(
                            left: radius,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: radius,
                              child: CircleAvatar(
                                radius: radius - 2,
                              ),
                            ),
                          ),

                          Positioned(
                            left: radius*2,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: radius,
                              child: CircleAvatar(
                                radius: radius - 2,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // show comments
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: <Widget>[
                            Text("32 comments", style: Styles.getSemiboldStyle(12, Colors.black54),)
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
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: new Row(
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.red, size: 20,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("1.1999, 39999k", style: Styles.getSemiboldStyle(12, Colors.black54),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}