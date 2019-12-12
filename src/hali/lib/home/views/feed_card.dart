import 'package:flutter/material.dart';
import 'package:hali/home/views/feed_action_box.dart';
import 'package:hali/home/views/feed_body_image.dart';
import 'package:hali/home/views/feed_card_container_top.dart';
import 'package:hali/home/views/feed_description_event.dart';
import 'package:hali/models/post_model.dart';

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
          FeedDescriptionEvent(title: this.postModel.title),
          //body
          FeedBodyImage(
            onTap: onTapCard,
            imageUrl: this.postModel.imageUrl,
            id: this.postModel.id,
          ),
          //action
          FeedActionBox(
            postModel: this.postModel,
          ),
          //Description
          this.postModel.userProfile != null
              ? FeedCardContainerTop(
                  userProfile: this.postModel.userProfile,
                  createdDate: this.postModel.lastModifiedDate,
                )
              : Container(),
        ],
      ),
    );
  }
}


