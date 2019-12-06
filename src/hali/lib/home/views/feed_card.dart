import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/utils/date_utils.dart';
import 'package:place_picker/uuid.dart';
class FeedCard extends StatelessWidget {

  final Function onTapCard;

  final PostModel postModel;

  const FeedCard({Key key, this.onTapCard, this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _DescriptionEvent(title: this.postModel.title),
          //body
          _BodyImage(onTap: onTapCard, imageUrl: this.postModel.imageUrl, id: this.postModel.id,),
          //action
          _ActionBox(postModel: this.postModel,),
          //Description
          this.postModel.userProfile != null ? _ContainerTop(userProfile: this.postModel.userProfile, createdDate: this.postModel.lastModifiedDate,) : new Container(),
        ],
      ),
    );
  }
}

class _ContainerTop extends StatelessWidget {

  final UserProfile userProfile;

  final String createdDate;

  _ContainerTop({this.userProfile, this.createdDate});

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
                        userProfile.email ?? "",
                        style: Styles.getSemiboldStyle(14, Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                      Text(DateUtils.timeAgo(this.createdDate),
                          style: Styles.getRegularStyle(12, Colors.grey[500]),
                          textAlign: TextAlign.left)
                    ],
                  ),
                ),
              ],
            ),
          ),
          // button

        ],
      ),
    );
  }
}


class _BodyImage extends StatelessWidget {

  final VoidCallback onTap;

  final int id;

  final String imageUrl;

  const _BodyImage({Key key, this.onTap, this.imageUrl, this.id }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthImage = MediaQuery.of(context).size.width - 16;
    final d = DateTime.now().toString();
    return GestureDetector(
      child: Container(
          child: Stack(
            children: <Widget>[
              Hero(
                tag: "$Uuid()@{$id}",
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? "",
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

  final String title;

  _DescriptionEvent({this.title});
  
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


class _ActionBox extends StatelessWidget {

  final double radius = 14.0;

  final PostModel postModel;

  _ActionBox({ this.postModel });

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
                this.postModel.distance != null ?
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.location_on, size: 20,),
                      ),

                      // show comments
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: <Widget>[
                            Text("32 km", style: Styles.getSemiboldStyle(12, Colors.black54),)
                          ],
                        ),
                      )

                    ],
                  ),
                ) : new Container(),

                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.monetization_on, size: 20,),
                      ),

                      // show comments
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: <Widget>[
                            Text("Free", style: Styles.getSemiboldStyle(12, Colors.black54),)
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
          this.postModel.numberLike != null ? 
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: new Row(
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.red, size: 20,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("$postModel.numberLike ?? 0", style: Styles.getSemiboldStyle(12, Colors.black54),),
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